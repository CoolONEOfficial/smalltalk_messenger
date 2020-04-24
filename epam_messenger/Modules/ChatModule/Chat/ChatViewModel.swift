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
        completion: @escaping (Error?) -> Void
    )
    func forwardMessage(
        _ chatModel: ChatModel,
        _ messageModel: MessageProtocol,
        completion: @escaping (Error?) -> Void
    )
    func deleteMessage(
        _ messageModel: MessageProtocol,
        completion: @escaping (Error?) -> Void
    )
    func deleteChat(
        completion: @escaping (Error?) -> Void
    )
    func createChat(
        completion: @escaping (Error?) -> Void
    )
    func presentForwardController(
        selectDelegate: ChatSelectDelegate
    )
    func goToChat(
        _ chatModel: ChatProtocol
    )
    func listenUserListData(
        completion: @escaping ([UserModel]?) -> Void
    )
    func listenChatData(
        completion: @escaping (ChatModel?) -> Void
    )
    func startTypingCurrentUser()
    func endTypingCurrentUser()
    func goToDetails()
    
    var chat: ChatProtocol { get }
    var baseQuery: FireQuery? { get }
    var lastTapCellContent: MessageCellContentProtocol! { get }
}

extension ChatViewModelProtocol {
    func deleteMessage(
        _ messageModel: MessageProtocol,
        completion: @escaping (Error?) -> Void = {_ in}
    ) {
        return deleteMessage(messageModel, completion: completion)
    }
    
    func sendMessage(
        attachments: [ChatViewController.MessageAttachment],
        messageText: String? = nil,
        completion: @escaping (Error?) -> Void = {_ in}
    ) {
        return sendMessage(attachments: attachments, messageText: messageText, completion: completion)
    }
    
    func deleteChat(
        completion: @escaping (Error?) -> Void = {_ in}
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
    
    var chat: ChatProtocol
    
    var lastTapCellContent: MessageCellContentProtocol!
    
    var baseQuery: FireQuery? {
        chat.documentId != nil ? firestoreService.chatBaseQuery(chat.documentId) : nil
    }
    
    // MARK: - Init
    
    let chatGroup = DispatchGroup()
    
    init(
        _ router: RouterProtocol,
        _ viewController: ChatViewControllerProtocol,
        _ chat: ChatProtocol,
        _ firestoreService: FirestoreServiceProtocol = FirestoreService(),
        _ storageService: StorageServiceProtocol = StorageService()
    ) {
        self.viewController = viewController
        self.router = router
        self.firestoreService = firestoreService
        self.storageService = storageService
        self.chat = chat
    }
    
    convenience init(
        router: RouterProtocol,
        viewController: ChatViewControllerProtocol,
        chat: ChatProtocol,
        firestoreService: FirestoreServiceProtocol = FirestoreService(),
        storageService: StorageServiceProtocol = StorageService()
    ) {
        self.init(router, viewController, chat, firestoreService, storageService)
    }
    
    func viewDidLoad() {
        chatGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.viewController.didChatLoad()
        }
    }
    
    convenience init(
        router: RouterProtocol,
        viewController: ChatViewControllerProtocol,
        userId: String,
        firestoreService: FirestoreServiceProtocol = FirestoreService(),
        storageService: StorageServiceProtocol = StorageService()
    ) {
        self.init(router, viewController,
                  ChatModel.fromUserId(userId),
                  firestoreService, storageService)
        
        chatGroup.enter()
        firestoreService.getChatData(userId: userId, completion: didChatLoad(_:))
    }
    
    private func didChatLoad(_ chat: ChatModel?) {
        if let chat = chat {
            self.chat = chat
        }
        self.chatGroup.leave()
    }
    
    func sendMessage(
        attachments: [ChatViewController.MessageAttachment],
        messageText: String? = nil,
        completion: @escaping (Error?) -> Void = {_ in}
    ) {
        let uploadGroup = DispatchGroup()
        var uploadKinds: [MessageModel.MessageKind?] = .init(repeating: nil, count: attachments.count)
        
        let uploadStartTimestamp = Date()
        for (index, attachment) in attachments.enumerated() {
            switch attachment {
            case .image(let image):
                uploadGroup.enter()
                storageService.uploadImage(
                    chatId: chat.documentId,
                    image: image,
                    timestamp: uploadStartTimestamp,
                    index: index
                ) { kind, err in
                    if let err = err {
                        self.viewController.presentErrorAlert(err.localizedDescription)
                    }
                    
                    if let kind = kind {
                        uploadKinds[index] = .image(path: kind.path, size: kind.size)
                    }
                    uploadGroup.leave()
                }
            case .data(let data):
                uploadGroup.enter()
                storageService.uploadAudio(
                    chatId: chat.documentId,
                    data: data
                ) { kind, err in
                    if let err = err {
                        self.viewController.presentErrorAlert(err.localizedDescription)
                    }
                    
                    if let kind = kind {
                        uploadKinds[index] = .audio(path: kind)
                    }
                    uploadGroup.leave()
                }
            default:
                fatalError()
            }
        }
        
        uploadGroup.notify(queue: .main) {
            if !(messageText?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) {
                uploadKinds.append(.text(messageText!))
            }
            
            self.firestoreService.sendMessage(
                chatId: self.chat.documentId,
                messageKind: uploadKinds.compactMap { $0 },
                completion: completion
            )
        }
    }
    
    func forwardMessage(
        _ chatModel: ChatModel,
        _ messageModel: MessageProtocol,
        completion: @escaping (Error?) -> Void
    ) {
        self.firestoreService.sendMessage(
            chatId: chatModel.documentId,
            messageKind: messageModel.forwardedKind(),
            completion: completion
        )
    }
    
    func deleteMessage(
        _ messageModel: MessageProtocol,
        completion: @escaping (Error?) -> Void = {_ in}
    ) {
        firestoreService.deleteMessage(
            chatId: chat.documentId,
            messageDocumentId: messageModel.documentId!,
            completion: completion
        )
    }
    
    func deleteChat(
        completion: @escaping (Error?) -> Void = {_ in}
    ) {
        firestoreService.deleteChat(chat: chat, completion: completion)
    }
    
    func listenUserListData(
        completion: @escaping ([UserModel]?) -> Void
    ) {
        firestoreService.listenUserListData(chat.users, completion: completion)
    }
    
    func listenChatData(completion: @escaping (ChatModel?) -> Void) {
        guard let chatId = chat.documentId else {
            completion(.fromUserId(chat.friendId!))
            return
        }
        
        firestoreService.listenChatData(chatId) { [weak self] chatModel in
            guard let self = self else { return }
            if let chatModel = chatModel {
                self.chat = chatModel
            }
            completion(chatModel)
        }
    }
    
    func startTypingCurrentUser() {
        guard chat.documentId != nil else { return }
        
        firestoreService.startTypingCurrentUser(chat.documentId)
    }
    
    func endTypingCurrentUser() {
        guard chat.documentId != nil else { return }
        
        firestoreService.endTypingCurrentUser()
    }
    
    func createChat(
        completion: @escaping (Error?) -> Void
    ) {
        chat.documentId = firestoreService.createChat(chat as! ChatModel, completion: completion)
    }
    
    func goToChat(_ chatModel: ChatProtocol) {
        guard let router = router as? ChatRouter else { return }
        
        router.showChat(chatModel)
    }
    
    func goToDetails() {
        guard let router = router as? ChatRouter else { return }
        
        router.showChatDetails(chat as! ChatModel, from: viewController)
    }
    
    func presentForwardController(selectDelegate: ChatSelectDelegate) {
        guard let router = router as? ChatListRouter else { return }
        
        return router.showChatPicker(selectDelegate: selectDelegate)
    }
}

extension ChatViewModel: MessageCellDelegate {
    
    func didAvatarTap(_ userId: String) {
        guard let router = router as? ChatRouter else { return }
        router.showChatDetails(userId, heroAnimations: false)
    }
    
    func didContentTap(_ content: MessageCellContentProtocol) {
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
        return firestoreService.getUserData(userId, completion: completion)
    }
    
}
