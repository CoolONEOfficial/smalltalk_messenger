//
//  ChatPhotoViewerDataSource.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 24.03.2020.
//

import Foundation
import NYTPhotoViewer
import FirebaseStorage
import SDWebImage

struct PhotoModel {
    let ref: StorageReference
}

class PhotoBox: NSObject, NYTPhoto {
    let path: String
    
    init(_ path: String) {
        self.path = path
    }
    
    var image: UIImage?
    
    var imageData: Data?
    
    var placeholderImage: UIImage?
    
    var attributedCaptionTitle: NSAttributedString?
    
    var attributedCaptionSummary: NSAttributedString?
    
    var attributedCaptionCredit: NSAttributedString?
}

extension PhotoBox {
    @objc
    override func isEqual(_ object: Any?) -> Bool {
        guard let otherPhoto = object as? PhotoBox else { return false }
        return path == otherPhoto.path
    }
}

class ChatPhotoViewerDataSource: NYTPhotoViewerArrayDataSource {
    
    // MARK: - Vars
    
    var data: [PhotoBox] {
        return photos as! [PhotoBox]
    }
    
    // MARK: - Init
    
    init(data: [PhotoBox] = []) {
        super.init(photos: data)
    }
    
    static func loadByChatId(
        chatId: String,
        cachedDatasource: ChatPhotoViewerDataSource?,
        initialIndexCompletion: @escaping (([StorageReference]) -> Int?),
        delegate: NYTPhotosViewControllerDelegate,
        completion: @escaping ((NYTPhotosViewController, ChatPhotoViewerDataSource)?, String?) -> Void
    ) {
        FirestoreService().listChatMedia(chatId: chatId) { mediaItems in
            guard let mediaItems = mediaItems else { return }
            
            let refs = mediaItems.map { $0.ref }
            
            let initialIndex = initialIndexCompletion(refs)

            if let initialIndex = initialIndex {

                guard cachedDatasource == nil || refs.count != cachedDatasource!.data.count else {
                    completion((
                        NYTPhotosViewController(
                            dataSource: cachedDatasource!,
                            initialPhotoIndex: initialIndex,
                            delegate: delegate
                        ),
                        cachedDatasource!
                    ), nil)
                    return
                }
                
                var photosViewController: NYTPhotosViewController!
                
                let dataSource = ChatPhotoViewerDataSource(
                    data: refs.enumerated().map { (index, ref) -> PhotoBox in
                        let photoBox = PhotoBox(ref.fullPath)
                        let cacheKey = ref.storageLocation
                        
                        photoBox.image = SDImageCache.shared.imageFromDiskCache(forKey: cacheKey)
                        
                        if photoBox.image == nil {
                            ref.getData(maxSize: Int64.max) { data, err in
                                guard err == nil else {
                                    debugPrint("Error while get image: \(err!.localizedDescription)")
                                    return
                                }
                                
                                let image = UIImage(data: data!)
                                SDImageCache.shared.storeImage(toMemory: image, forKey: cacheKey)
                                photoBox.image = image
                                
                                photosViewController.updatePhoto(at: index)
                            }
                        }
                        
                        return photoBox
                    }
                )
                
                photosViewController = NYTPhotosViewController(
                    dataSource: dataSource,
                    initialPhotoIndex: initialIndex,
                    delegate: delegate
                )
                completion((
                    photosViewController,
                    dataSource
                ), nil)
            } else {
                completion(nil, "Photo has been deleted by the owner.")
            }
        }
    }
    
}
