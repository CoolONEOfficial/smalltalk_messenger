//
//  ChatDetailsMediaViewController.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 10.04.2020.
//

import UIKit
import XLPagerTabStrip
import NYTPhotoViewer

class ChatDetailsMediaViewController: UICollectionViewController {
    
    // MARK: - Vars
    
    var data: [MediaModel] = [] {
        didSet {
            collectionView.animateItemChanges(oldData: oldValue, newData: data, updateData: {})
        }
    }
    
    let cellSpacing: CGFloat = 2
    let cellsPerRow: CGFloat = 3
    
    var viewModel: ChatDetailsViewModelProtocol
    
    var chatViewController: ChatViewControllerProtocol?
    var localDataSource: ChatPhotoViewerDataSource?
    
    // MARK: - Init
    
    init(
        viewModel: ChatDetailsViewModelProtocol,
        chatViewController: ChatViewControllerProtocol?
    ) {
        self.viewModel = viewModel
        self.chatViewController = chatViewController
        
        let layout: UICollectionViewFlowLayout = .init()
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        let width = (UIScreen.main.bounds.width - cellSpacing * (cellsPerRow - 1)) / cellsPerRow
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.itemSize = .init(width: width, height: width)
        super.init(collectionViewLayout: layout)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        collectionView.register(cellType: MediaCell.self)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundView = .init()
        view.backgroundColor = .clear
        collectionView.backgroundColor = .clear
    }
    
    func updateData(_ chat: ChatProtocol) {
        guard let chatId = chat.documentId else { return }
        
        FirestoreService().listChatMedia(chatId: chatId) { media in
            if let media = media {
                self.data = media
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MediaCell.self)
        cell.loadMedia(data[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension ChatDetailsMediaViewController: MediaCellDelegate {
    
    func didMediaTap(_ media: MediaProtocol) {
        ChatPhotoViewerDataSource.loadByChatId(
            chatId: viewModel.chatModel.documentId,
            cachedDatasource: chatViewController != nil
                ? chatViewController?.photosViewerDataSource
                : localDataSource,
            initialIndexCompletion: { refs in
                refs.firstIndex { ref in
                    ref.fullPath == media.path
                }
            },
            delegate: self
        ) { [weak self] photos, errorText in
            guard let self = self else { return }
            guard let photos = photos else {
                self.chatViewController?.presentErrorAlert(errorText ?? "Unknown error")
                return
            }

            let photosController = photos.0
            let photosDataSource = photos.1
            if self.chatViewController != nil {
                self.chatViewController?.photosViewerDataSource = photosDataSource
            } else {
                self.localDataSource = photosDataSource
            }
            
            self.present(photosController, animated: true, completion: nil)
        }
    }
    
}

extension ChatDetailsMediaViewController: NYTPhotosViewControllerDelegate {
    
    func photosViewController(_ photosViewController: NYTPhotosViewController, referenceViewFor photo: NYTPhoto) -> UIView? {
        guard let box = photo as? PhotoBox else { return nil }
        
        for (index, media) in data.enumerated() where box.path == media.path {
            if let cell = collectionView.cellForItem(at: .init(row: index, section: 0)) as? MediaCell {
                return cell.image
            }
        }
        
        return nil
    }
    
    func photosViewController(_ photosViewController: NYTPhotosViewController, maximumZoomScaleFor photo: NYTPhoto) -> CGFloat {
        return 2
    }
    
}

extension ChatDetailsMediaViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        .init(stringLiteral: "Media")
    }
}
