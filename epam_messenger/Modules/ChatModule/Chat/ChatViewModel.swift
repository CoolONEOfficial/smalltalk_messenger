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
    func leaveChat(
        completion: @escaping (Bool) -> Void
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
    
    func leaveChat(
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        return leaveChat(completion: completion)
    }
}

class ChatViewModel: ChatViewModelProtocol {
    
    // MARK: - Vars
    
    let router: RouterProtocol
    var viewController: ChatViewControllerProtocol
    
    let firestoreService: FirestoreServiceProtocol
    let storageService: StorageServiceProtocol
    
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
        storageService: StorageServiceProtocol = StorageService()
    ) {
        self.viewController = viewController
        self.router = router
        self.chat = chat
        self.firestoreService = firestoreService
        self.storageService = storageService
    }
    
    init(
        router: RouterProtocol,
        viewController: ChatViewControllerProtocol,
        userId: String,
        firestoreService: FirestoreServiceProtocol = FirestoreService(),
        storageService: StorageServiceProtocol = StorageService()
    ) {
        self.viewController = viewController
        self.router = router
        self.chat = ChatModel.fromUserId(userId)
        self.firestoreService = firestoreService
        self.storageService = storageService
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
                    chatId: chat.documentId,
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
                    chatId: chat.documentId,
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
                chatId: self.chat.documentId,
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
            chatId: chatModel.documentId,
            messageKind: messageModel.forwardedKind(),
            completion: completion
        )
    }
    
    func deleteMessage(
        _ messageModel: MessageProtocol,
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        firestoreService.deleteMessage(
            chatId: chat.documentId,
            messageDocumentId: messageModel.documentId!,
            completion: completion
        )
    }
    
    func leaveChat(
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        firestoreService.leaveChat(
            chatId: chat.documentId,
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
