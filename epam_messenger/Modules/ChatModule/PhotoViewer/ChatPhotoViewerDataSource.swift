//
//  ChatPhotoViewerDataSource.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 24.03.2020.
//

import Foundation
import NYTPhotoViewer
import FirebaseStorage

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
    
}
