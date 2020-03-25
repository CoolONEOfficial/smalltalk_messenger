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
    func getChatModel() -> ChatModel
    func firestoreQuery() -> FireQuery
    func sendMessage(
        _ messageText: String,
        attachments: [ChatViewController.MessageAttachment],
        completion: @escaping (Bool) -> Void
    )
    func deleteMessage(
        _ messageModel: MessageProtocol,
        completion: @escaping (Bool) -> Void
    )
    
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
        _ messageText: String,
        attachments: [ChatViewController.MessageAttachment],
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        return sendMessage(messageText, attachments: attachments, completion: completion)
    }
}

class ChatViewModel: ChatViewModelProtocol {
    let router: RouterProtocol
    let firestoreService: FirestoreServiceProtocol
    let storageService: StorageServiceProtocol
    
    let viewController: ChatViewControllerProtocol
    
    let chatModel: ChatModel
    
    var lastTapCellContent: MessageCellContentProtocol!
    
    init(
        viewController: ChatViewControllerProtocol,
        router: RouterProtocol,
        chatModel: ChatModel,
        firestoreService: FirestoreServiceProtocol = FirestoreService(),
        storageService: StorageServiceProtocol = StorageService()
    ) {
        self.viewController = viewController
        self.router = router
        self.chatModel = chatModel
        self.firestoreService = firestoreService
        self.storageService = storageService
    }
    
    func getChatModel() -> ChatModel {
        return self.chatModel
    }
    
    func firestoreQuery() -> FireQuery {
        return firestoreService.createChatQuery(chatModel)
    }
    
    func sendMessage(
        _ messageText: String,
        attachments: [ChatViewController.MessageAttachment],
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        let uploadGroup = DispatchGroup()
        var uploadKinds: [MessageModel.MessageKind] = messageText
            .trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? []
            : [ .text(messageText) ]
        
        for (index, attachment) in attachments.enumerated() {
            switch attachment {
            case .image(let image):
                uploadGroup.enter()
                storageService.uploadImage(
                    chatDocumentId: chatModel.documentId,
                    image: image,
                    nameSuffix: "_\(index)"
                ) { kind in
                    if let kind = kind {
                        uploadKinds.insert(kind, at: 0)
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
}

extension ChatViewModel: MessageCellDelegate {
    func didTapContent(_ content: MessageCellContentProtocol) {
        lastTapCellContent = content
        switch content {
        case let messageContent as MessageImageContent:
            storageService.listChatFiles(chatDocumentId: chatModel.documentId) { refs in
                if let refs = refs {
                    let initialIndex = refs.firstIndex { ref in
                        return ref.fullPath == messageContent.imageMessage.image!.path
                    }
                    self.viewController.presentPhotoViewer(
                        refs,
                        initialIndex: initialIndex!
                    )
                }
            }
        default: break
        }
    }
}
