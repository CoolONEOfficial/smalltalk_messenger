//
//  ChatViewModel.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 08.03.2020.
//

import Foundation
import Firebase
import InputBarAccessoryView
import NYTPhotoViewer

protocol ChatViewModelProtocol: ViewModelProtocol, AutoMockable, MessageCellDelegate {
    func sendMessage(
        attachments: [ChatViewController.MessageAttachment],
        messageText: String?,
        completion: @escaping (Bool) -> Void
    )
    func forwardMessage(
        _ chatModel: ChatModel,
        _ messageModel: MessageProtocol,
        completion: @escaping (Bool) -> Void
    )
    func deleteMessage(
        _ messageModel: MessageProtocol,
        completion: @escaping (Bool) -> Void
    )
    func deleteChat(
        completion: @escaping (Bool) -> Void
    )
    func pickImages(
        viewController: UIViewController,
        completion: @escaping (UIImage) -> Void
    )
    func createForwardViewController(
        forwardDelegate: ForwardDelegate
    ) -> UIViewController
    func goToChat(
        _ chatModel: ChatProtocol
    )
    func userData(
        _ userId: String,
        completion: @escaping (UserModel?) -> Void
    )
    func userListData(
        _ userList: [String],
        completion: @escaping ([UserModel]?) -> Void
    )
    func startTypingCurrentUser()
    func endTypingCurrentUser()
    func goToDetails()
    
    var chat: ChatProtocol { get }
    var baseQuery: FireQuery { get }
    var lastTapCellContent: MessageCellContentProtocol! { get }
}

extension ChatViewModelProtocol {
    func deleteMessage(
        _ messageModel: MessageProtocol,
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        return deleteMessage(messageModel, completion: completion)
    }
    
    func sendMessage(
        attachments: [ChatViewController.MessageAttachment],
        messageText: String? = nil,
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        return sendMessage(attachments: attachments, messageText: messageText, completion: completion)
    }
    
    func deleteChat(
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        return deleteChat(completion: completion)
    }
}

class ChatViewModel: ChatViewModelProtocol {
    
    // MARK: - Vars
    
    let router: RouterProtocol
    var viewController: ChatViewControllerProtocol
    
    let firestoreService: FirestoreServiceProtocol
    let storageService: StorageServiceProtocol
    let imagePickerService: ImagePickerServiceProtocol
    
    let chat: ChatProtocol
    
    var lastTapCellContent: MessageCellContentProtocol!
    
    var baseQuery: FireQuery {
        firestoreService.chatBaseQuery(chat.documentId)
    }
    
    // MARK: - Init
    
    init(
        router: RouterProtocol,
        viewController: ChatViewControllerProtocol,
        chat: ChatProtocol,
        firestoreService: FirestoreServiceProtocol = FirestoreService(),
        storageService: StorageServiceProtocol = StorageService(),
        imagePickerService: ImagePickerServiceProtocol = ImagePickerService()
    ) {
        self.viewController = viewController
        self.router = router
        self.chat = chat
        self.firestoreService = firestoreService
        self.storageService = storageService
        self.imagePickerService = imagePickerService
    }
    
    init(
        router: RouterProtocol,
        viewController: ChatViewControllerProtocol,
        userId: String,
        firestoreService: FirestoreServiceProtocol = FirestoreService(),
        storageService: StorageServiceProtocol = StorageService(),
        imagePickerService: ImagePickerServiceProtocol = ImagePickerService()
    ) {
        self.viewController = viewController
        self.router = router
        self.chat = ChatModel.fromUserId(userId)
        self.firestoreService = firestoreService
        self.storageService = storageService
        self.imagePickerService = imagePickerService
    }
    
    func sendMessage(
        attachments: [ChatViewController.MessageAttachment],
        messageText: String? = nil,
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        let uploadGroup = DispatchGroup()
        var uploadKinds: [MessageModel.MessageKind] = messageText?
            .trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
            ? []
            : [ .text(messageText!) ]
        
        let uploadStartTimestamp = Date()
        for (index, attachment) in attachments.enumerated() {
            switch attachment {
            case .image(let image):
                uploadGroup.enter()
                storageService.uploadImage(
                    chatDocumentId: chat.documentId,
                    image: image,
                    timestamp: uploadStartTimestamp,
                    index: attachments.count - index
                ) { kind in
                    if let kind = kind {
                        uploadKinds.insert(kind, at: 0)
                    }
                    uploadGroup.leave()
                }
            case .data(let data):
                uploadGroup.enter()
                storageService.uploadAudio(
                    chatDocumentId: chat.documentId,
                    data: data
                ) { kind in
                    if let kind = kind {
                        uploadKinds.append(kind)
                    }
                    uploadGroup.leave()
                }
            default:
                fatalError()
            }
        }
        
        uploadGroup.notify(queue: .main) {
            self.firestoreService.sendMessage(
                chatDocumentId: self.chat.documentId,
                messageKind: uploadKinds,
                completion: completion
            )
        }
    }
    
    func forwardMessage(
        _ chatModel: ChatModel,
        _ messageModel: MessageProtocol,
        completion: @escaping (Bool) -> Void
    ) {
        self.firestoreService.sendMessage(
            chatDocumentId: chatModel.documentId,
            messageKind: messageModel.forwardedKind(Auth.auth().currentUser!.uid),
            completion: completion
        )
    }
    
    func deleteMessage(
        _ messageModel: MessageProtocol,
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        firestoreService.deleteMessage(
            chatDocumentId: chat.documentId,
            messageDocumentId: messageModel.documentId!,
            completion: completion
        )
    }
    
    func deleteChat(
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        firestoreService.deleteChat(
            chatDocumentId: chat.documentId,
            completion: completion
        )
    }
    
    func userData(
        _ userId: String,
        completion: @escaping (UserModel?) -> Void
    ) {
        firestoreService.userData(userId, completion: completion)
    }
    
    func userListData(
        _ userList: [String],
        completion: @escaping ([UserModel]?) -> Void
    ) {
        firestoreService.userListData(userList, completion: completion)
    }
    
    func startTypingCurrentUser() {
        firestoreService.startTypingCurrentUser(chat.documentId)
    }
    
    func endTypingCurrentUser() {
        firestoreService.endTypingCurrentUser()
    }
    
    func goToChat(_ chatModel: ChatProtocol) {
        guard let router = router as? ChatRouter else { return }
        
        router.showChat(chatModel)
    }
    
    func goToDetails() {
        guard let router = router as? ChatRouter else { return }
        
        router.showChatDetails(chat, from: viewController)
    }
    
    func pickImages(
        viewController: UIViewController,
        completion: @escaping (UIImage) -> Void
    ) {
        imagePickerService.pickImages(viewController: viewController, completion: completion)
    }
    
    func createForwardViewController(forwardDelegate: ForwardDelegate) -> UIViewController {
        return AssemblyBuilder().createChatListModule(
            router: router,
            forwardDelegate: forwardDelegate
        )
    }
}

extension ChatViewModel: MessageCellDelegate {
    
    func didTapContent(_ content: MessageCellContentProtocol) {
        lastTapCellContent = content
        switch content {
        case let messageContent as MessageImageContent:
            
            ChatPhotoViewerDataSource.loadByChatId(
                chatId: chat.documentId,
                cachedDatasource: viewController.photosViewerDataSource,
                initialIndexCompletion: { refs in
                    refs.firstIndex { ref in
                        ref.fullPath == messageContent.imageMessage.kindImage(at: messageContent.kindIndex)!.path
                    }
                },
                delegate: viewController as! NYTPhotosViewControllerDelegate
            ) { [weak self] photos, errorText in
                guard let self = self else { return }
                guard let photos = photos else {
                    self.viewController.presentErrorAlert(errorText ?? "Unknown error")
                    return
                }

                let photosController = photos.0
                let photosDataSource = photos.1
                self.viewController.photosViewerDataSource = photosDataSource
                
                self.viewController.present(photosController, animated: true, completion: nil)
            }

        default: break
        }
    }
    
    func didError(_ text: String) {
        viewController.presentErrorAlert(text)
    }
    
    func cellUserData(_ userId: String, completion: @escaping (UserModel?) -> Void) {
        return firestoreService.userData(userId, completion: completion)
    }
    
}
