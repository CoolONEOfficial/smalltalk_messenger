//
//  ChatViewModel.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 08.03.2020.
//

import Foundation
import Firebase
import InputBarAccessoryView

protocol ChatViewModelProtocol: ViewModelProtocol, AutoMockable, MessageCellDelegate {
    func firestoreQuery() -> FireQuery
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
    func createForwardViewController(forwardDelegate: ForwardDelegateProtocol) -> UIViewController
    func goToChat(
        _ chatModel: ChatModel
    )
    
    var chatModel: ChatModel { get }
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
    let router: RouterProtocol
    let firestoreService: FirestoreServiceProtocol
    let storageService: StorageServiceProtocol
    let imagePickerService: ImagePickerServiceProtocol
    
    let viewController: ChatViewControllerProtocol
    
    let chatModel: ChatModel
    
    var lastTapCellContent: MessageCellContentProtocol!
    
    init(
        viewController: ChatViewControllerProtocol,
        router: RouterProtocol,
        chatModel: ChatModel,
        firestoreService: FirestoreServiceProtocol = FirestoreService(),
        storageService: StorageServiceProtocol = StorageService(),
        imagePickerService: ImagePickerServiceProtocol = ImagePickerService()
    ) {
        self.viewController = viewController
        self.router = router
        self.chatModel = chatModel
        self.firestoreService = firestoreService
        self.storageService = storageService
        self.imagePickerService = imagePickerService
    }
    
    func firestoreQuery() -> FireQuery {
        return firestoreService.createChatQuery(chatModel)
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
                    chatDocumentId: chatModel.documentId,
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
                    chatDocumentId: chatModel.documentId,
                    data: data
                ) { kind in
                    if let kind = kind {
                        uploadKinds.append(kind)
                    }
                    uploadGroup.leave()
                }
            default:
                fatalError() // TODO: other attachments
            }
        }
        
        uploadGroup.notify(queue: .main) {
            self.firestoreService.sendMessage(
                chatDocumentId: self.chatModel.documentId,
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
        firestoreService.sendMessage(
            chatDocumentId: chatModel.documentId,
            messageKind: messageModel.forwardedKind(.init(name: "User", surname: "Userov")), // TODO: sender forward user
            completion: completion
        )
    }
    
    func deleteMessage(
        _ messageModel: MessageProtocol,
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        firestoreService.deleteMessage(
            chatDocumentId: chatModel.documentId,
            messageDocumentId: messageModel.documentId!,
            completion: completion
        )
    }
    
    func deleteChat(
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        firestoreService.deleteChat(
            chatDocumentId: chatModel.documentId,
            completion: completion
        )
    }
    
    func goToChat(_ chatModel: ChatModel) {
        router.showChat(chatModel)
    }
    
    func pickImages(
        viewController: UIViewController,
        completion: @escaping (UIImage) -> Void
    ) {
        imagePickerService.pickImages(viewController: viewController, completion: completion)
    }
    
    func createForwardViewController(forwardDelegate: ForwardDelegateProtocol) -> UIViewController {
        return AssemblyBuilder().createChatListModule(router: router, forwardDelegate: forwardDelegate)
    }
}

extension ChatViewModel: MessageCellDelegate {
    
    func didTapContent(_ content: MessageCellContentProtocol) {
        lastTapCellContent = content
        switch content {
        case let messageContent as MessageImageContent:
            firestoreService.listChatMedia(chatDocumentId: chatModel.documentId) { mediaItems in
                let refs = mediaItems!.map { Storage.storage().reference(withPath: $0.path) }
                
                let initialIndex = refs.firstIndex { ref in
                    return ref.fullPath == messageContent.imageMessage.kindImage(at: messageContent.kindIndex)!.path
                }
                if let initialIndex = initialIndex {
                    self.viewController.presentPhotoViewer(
                        refs,
                        initialIndex: initialIndex
                    )
                } else {
                    self.viewController.presentErrorAlert("Photo has been deleted by the owner.")
                }
                self.viewController.presentPhotoViewer(
                    refs,
                    initialIndex: initialIndex!
                )
            }
        default: break
        }
    }
    
    func didError(_ text: String) {
        viewController.presentErrorAlert(text)
    }
    
}
