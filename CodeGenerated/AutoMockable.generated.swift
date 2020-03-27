// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

import Firebase














class ChatViewControllerProtocolMock: ChatViewControllerProtocol {

    //MARK: - presentPhotoViewer

    var presentPhotoViewerInitialIndexCallsCount = 0
    var presentPhotoViewerInitialIndexCalled: Bool {
        return presentPhotoViewerInitialIndexCallsCount > 0
    }
    var presentPhotoViewerInitialIndexReceivedArguments: (storageRefs: [StorageReference], initialIndex: Int)?
    var presentPhotoViewerInitialIndexReceivedInvocations: [(storageRefs: [StorageReference], initialIndex: Int)] = []
    var presentPhotoViewerInitialIndexClosure: (([StorageReference], Int) -> Void)?

    func presentPhotoViewer(_ storageRefs: [StorageReference], initialIndex: Int) {
        presentPhotoViewerInitialIndexCallsCount += 1
        presentPhotoViewerInitialIndexReceivedArguments = (storageRefs: storageRefs, initialIndex: initialIndex)
        presentPhotoViewerInitialIndexReceivedInvocations.append((storageRefs: storageRefs, initialIndex: initialIndex))
        presentPhotoViewerInitialIndexClosure?(storageRefs, initialIndex)
    }

}
class ChatViewModelProtocolMock: ChatViewModelProtocol {
    var lastTapCellContent: MessageCellContentProtocol!

    //MARK: - getChatModel

    var getChatModelCallsCount = 0
    var getChatModelCalled: Bool {
        return getChatModelCallsCount > 0
    }
    var getChatModelReturnValue: ChatModel!
    var getChatModelClosure: (() -> ChatModel)?

    func getChatModel() -> ChatModel {
        getChatModelCallsCount += 1
        return getChatModelClosure.map({ $0() }) ?? getChatModelReturnValue
    }

    //MARK: - firestoreQuery

    var firestoreQueryCallsCount = 0
    var firestoreQueryCalled: Bool {
        return firestoreQueryCallsCount > 0
    }
    var firestoreQueryReturnValue: FireQuery!
    var firestoreQueryClosure: (() -> FireQuery)?

    func firestoreQuery() -> FireQuery {
        firestoreQueryCallsCount += 1
        return firestoreQueryClosure.map({ $0() }) ?? firestoreQueryReturnValue
    }

    //MARK: - sendMessage

    var sendMessageAttachmentsCompletionCallsCount = 0
    var sendMessageAttachmentsCompletionCalled: Bool {
        return sendMessageAttachmentsCompletionCallsCount > 0
    }
    var sendMessageAttachmentsCompletionReceivedArguments: (messageText: String, attachments: [ChatViewController.MessageAttachment], completion: (Bool) -> Void)?
    var sendMessageAttachmentsCompletionReceivedInvocations: [(messageText: String, attachments: [ChatViewController.MessageAttachment], completion: (Bool) -> Void)] = []
    var sendMessageAttachmentsCompletionClosure: ((String, [ChatViewController.MessageAttachment], @escaping (Bool) -> Void) -> Void)?

    func sendMessage(        _ messageText: String,        attachments: [ChatViewController.MessageAttachment],        completion: @escaping (Bool) -> Void    ) {
        sendMessageAttachmentsCompletionCallsCount += 1
        sendMessageAttachmentsCompletionReceivedArguments = (messageText: messageText, attachments: attachments, completion: completion)
        sendMessageAttachmentsCompletionReceivedInvocations.append((messageText: messageText, attachments: attachments, completion: completion))
        sendMessageAttachmentsCompletionClosure?(messageText, attachments, completion)
    }

    //MARK: - deleteMessage

    var deleteMessageCompletionCallsCount = 0
    var deleteMessageCompletionCalled: Bool {
        return deleteMessageCompletionCallsCount > 0
    }
    var deleteMessageCompletionReceivedArguments: (messageModel: MessageProtocol, completion: (Bool) -> Void)?
    var deleteMessageCompletionReceivedInvocations: [(messageModel: MessageProtocol, completion: (Bool) -> Void)] = []
    var deleteMessageCompletionClosure: ((MessageProtocol, @escaping (Bool) -> Void) -> Void)?

    func deleteMessage(        _ messageModel: MessageProtocol,        completion: @escaping (Bool) -> Void    ) {
        deleteMessageCompletionCallsCount += 1
        deleteMessageCompletionReceivedArguments = (messageModel: messageModel, completion: completion)
        deleteMessageCompletionReceivedInvocations.append((messageModel: messageModel, completion: completion))
        deleteMessageCompletionClosure?(messageModel, completion)
    }

    //MARK: - pickImages

    var pickImagesViewControllerCompletionCallsCount = 0
    var pickImagesViewControllerCompletionCalled: Bool {
        return pickImagesViewControllerCompletionCallsCount > 0
    }
    var pickImagesViewControllerCompletionReceivedArguments: (viewController: UIViewController, completion: (UIImage) -> Void)?
    var pickImagesViewControllerCompletionReceivedInvocations: [(viewController: UIViewController, completion: (UIImage) -> Void)] = []
    var pickImagesViewControllerCompletionClosure: ((UIViewController, @escaping (UIImage) -> Void) -> Void)?

    func pickImages(        viewController: UIViewController,        completion: @escaping (UIImage) -> Void    ) {
        pickImagesViewControllerCompletionCallsCount += 1
        pickImagesViewControllerCompletionReceivedArguments = (viewController: viewController, completion: completion)
        pickImagesViewControllerCompletionReceivedInvocations.append((viewController: viewController, completion: completion))
        pickImagesViewControllerCompletionClosure?(viewController, completion)
    }

    //MARK: - didTapContent

    var didTapContentCallsCount = 0
    var didTapContentCalled: Bool {
        return didTapContentCallsCount > 0
    }
    var didTapContentReceivedContent: MessageCellContentProtocol?
    var didTapContentReceivedInvocations: [MessageCellContentProtocol] = []
    var didTapContentClosure: ((MessageCellContentProtocol) -> Void)?

    func didTapContent(_ content: MessageCellContentProtocol) {
        didTapContentCallsCount += 1
        didTapContentReceivedContent = content
        didTapContentReceivedInvocations.append(content)
        didTapContentClosure?(content)
    }

    //MARK: - viewDidLoad

    var viewDidLoadCallsCount = 0
    var viewDidLoadCalled: Bool {
        return viewDidLoadCallsCount > 0
    }
    var viewDidLoadClosure: (() -> Void)?

    func viewDidLoad() {
        viewDidLoadCallsCount += 1
        viewDidLoadClosure?()
    }

    //MARK: - viewWillAppear

    var viewWillAppearAnimatedCallsCount = 0
    var viewWillAppearAnimatedCalled: Bool {
        return viewWillAppearAnimatedCallsCount > 0
    }
    var viewWillAppearAnimatedReceivedAnimated: Bool?
    var viewWillAppearAnimatedReceivedInvocations: [Bool] = []
    var viewWillAppearAnimatedClosure: ((Bool) -> Void)?

    func viewWillAppear(animated: Bool) {
        viewWillAppearAnimatedCallsCount += 1
        viewWillAppearAnimatedReceivedAnimated = animated
        viewWillAppearAnimatedReceivedInvocations.append(animated)
        viewWillAppearAnimatedClosure?(animated)
    }

    //MARK: - viewDidAppear

    var viewDidAppearAnimatedCallsCount = 0
    var viewDidAppearAnimatedCalled: Bool {
        return viewDidAppearAnimatedCallsCount > 0
    }
    var viewDidAppearAnimatedReceivedAnimated: Bool?
    var viewDidAppearAnimatedReceivedInvocations: [Bool] = []
    var viewDidAppearAnimatedClosure: ((Bool) -> Void)?

    func viewDidAppear(animated: Bool) {
        viewDidAppearAnimatedCallsCount += 1
        viewDidAppearAnimatedReceivedAnimated = animated
        viewDidAppearAnimatedReceivedInvocations.append(animated)
        viewDidAppearAnimatedClosure?(animated)
    }

    //MARK: - viewWillDisappear

    var viewWillDisappearAnimatedCallsCount = 0
    var viewWillDisappearAnimatedCalled: Bool {
        return viewWillDisappearAnimatedCallsCount > 0
    }
    var viewWillDisappearAnimatedReceivedAnimated: Bool?
    var viewWillDisappearAnimatedReceivedInvocations: [Bool] = []
    var viewWillDisappearAnimatedClosure: ((Bool) -> Void)?

    func viewWillDisappear(animated: Bool) {
        viewWillDisappearAnimatedCallsCount += 1
        viewWillDisappearAnimatedReceivedAnimated = animated
        viewWillDisappearAnimatedReceivedInvocations.append(animated)
        viewWillDisappearAnimatedClosure?(animated)
    }

    //MARK: - viewDidDisappear

    var viewDidDisappearAnimatedCallsCount = 0
    var viewDidDisappearAnimatedCalled: Bool {
        return viewDidDisappearAnimatedCallsCount > 0
    }
    var viewDidDisappearAnimatedReceivedAnimated: Bool?
    var viewDidDisappearAnimatedReceivedInvocations: [Bool] = []
    var viewDidDisappearAnimatedClosure: ((Bool) -> Void)?

    func viewDidDisappear(animated: Bool) {
        viewDidDisappearAnimatedCallsCount += 1
        viewDidDisappearAnimatedReceivedAnimated = animated
        viewDidDisappearAnimatedReceivedInvocations.append(animated)
        viewDidDisappearAnimatedClosure?(animated)
    }

}
class FirestoreServiceProtocolMock: FirestoreServiceProtocol {

    //MARK: - createChatQuery

    var createChatQueryCallsCount = 0
    var createChatQueryCalled: Bool {
        return createChatQueryCallsCount > 0
    }
    var createChatQueryReceivedChatModel: ChatModel?
    var createChatQueryReceivedInvocations: [ChatModel] = []
    var createChatQueryReturnValue: Query!
    var createChatQueryClosure: ((ChatModel) -> Query)?

    func createChatQuery(_ chatModel: ChatModel) -> Query {
        createChatQueryCallsCount += 1
        createChatQueryReceivedChatModel = chatModel
        createChatQueryReceivedInvocations.append(chatModel)
        return createChatQueryClosure.map({ $0(chatModel) }) ?? createChatQueryReturnValue
    }

    //MARK: - sendMessage

    var sendMessageChatDocumentIdMessageKindCompletionCallsCount = 0
    var sendMessageChatDocumentIdMessageKindCompletionCalled: Bool {
        return sendMessageChatDocumentIdMessageKindCompletionCallsCount > 0
    }
    var sendMessageChatDocumentIdMessageKindCompletionReceivedArguments: (chatDocumentId: String, messageKind: [MessageModel.MessageKind], completion: (Bool) -> Void)?
    var sendMessageChatDocumentIdMessageKindCompletionReceivedInvocations: [(chatDocumentId: String, messageKind: [MessageModel.MessageKind], completion: (Bool) -> Void)] = []
    var sendMessageChatDocumentIdMessageKindCompletionClosure: ((String, [MessageModel.MessageKind], @escaping (Bool) -> Void) -> Void)?

    func sendMessage(        chatDocumentId: String,        messageKind: [MessageModel.MessageKind],        completion: @escaping (Bool) -> Void    ) {
        sendMessageChatDocumentIdMessageKindCompletionCallsCount += 1
        sendMessageChatDocumentIdMessageKindCompletionReceivedArguments = (chatDocumentId: chatDocumentId, messageKind: messageKind, completion: completion)
        sendMessageChatDocumentIdMessageKindCompletionReceivedInvocations.append((chatDocumentId: chatDocumentId, messageKind: messageKind, completion: completion))
        sendMessageChatDocumentIdMessageKindCompletionClosure?(chatDocumentId, messageKind, completion)
    }

    //MARK: - deleteMessage

    var deleteMessageChatDocumentIdMessageDocumentIdCompletionCallsCount = 0
    var deleteMessageChatDocumentIdMessageDocumentIdCompletionCalled: Bool {
        return deleteMessageChatDocumentIdMessageDocumentIdCompletionCallsCount > 0
    }
    var deleteMessageChatDocumentIdMessageDocumentIdCompletionReceivedArguments: (chatDocumentId: String, messageDocumentId: String, completion: (Bool) -> Void)?
    var deleteMessageChatDocumentIdMessageDocumentIdCompletionReceivedInvocations: [(chatDocumentId: String, messageDocumentId: String, completion: (Bool) -> Void)] = []
    var deleteMessageChatDocumentIdMessageDocumentIdCompletionClosure: ((String, String, @escaping (Bool) -> Void) -> Void)?

    func deleteMessage(        chatDocumentId: String,        messageDocumentId: String,        completion: @escaping (Bool) -> Void    ) {
        deleteMessageChatDocumentIdMessageDocumentIdCompletionCallsCount += 1
        deleteMessageChatDocumentIdMessageDocumentIdCompletionReceivedArguments = (chatDocumentId: chatDocumentId, messageDocumentId: messageDocumentId, completion: completion)
        deleteMessageChatDocumentIdMessageDocumentIdCompletionReceivedInvocations.append((chatDocumentId: chatDocumentId, messageDocumentId: messageDocumentId, completion: completion))
        deleteMessageChatDocumentIdMessageDocumentIdCompletionClosure?(chatDocumentId, messageDocumentId, completion)
    }

    //MARK: - deleteChat

    var deleteChatChatDocumentIdCompletionCallsCount = 0
    var deleteChatChatDocumentIdCompletionCalled: Bool {
        return deleteChatChatDocumentIdCompletionCallsCount > 0
    }
    var deleteChatChatDocumentIdCompletionReceivedArguments: (chatDocumentId: String, completion: (Bool) -> Void)?
    var deleteChatChatDocumentIdCompletionReceivedInvocations: [(chatDocumentId: String, completion: (Bool) -> Void)] = []
    var deleteChatChatDocumentIdCompletionClosure: ((String, @escaping (Bool) -> Void) -> Void)?

    func deleteChat(        chatDocumentId: String,        completion: @escaping (Bool) -> Void    ) {
        deleteChatChatDocumentIdCompletionCallsCount += 1
        deleteChatChatDocumentIdCompletionReceivedArguments = (chatDocumentId: chatDocumentId, completion: completion)
        deleteChatChatDocumentIdCompletionReceivedInvocations.append((chatDocumentId: chatDocumentId, completion: completion))
        deleteChatChatDocumentIdCompletionClosure?(chatDocumentId, completion)
    }

}
class ImagePickerServiceProtocolMock: ImagePickerServiceProtocol {

    //MARK: - pickImages

    var pickImagesViewControllerCompletionCallsCount = 0
    var pickImagesViewControllerCompletionCalled: Bool {
        return pickImagesViewControllerCompletionCallsCount > 0
    }
    var pickImagesViewControllerCompletionReceivedArguments: (viewController: UIViewController, completion: (UIImage) -> Void)?
    var pickImagesViewControllerCompletionReceivedInvocations: [(viewController: UIViewController, completion: (UIImage) -> Void)] = []
    var pickImagesViewControllerCompletionClosure: ((UIViewController, @escaping (UIImage) -> Void) -> Void)?

    func pickImages(        viewController: UIViewController,        completion: @escaping (UIImage) -> Void    ) {
        pickImagesViewControllerCompletionCallsCount += 1
        pickImagesViewControllerCompletionReceivedArguments = (viewController: viewController, completion: completion)
        pickImagesViewControllerCompletionReceivedInvocations.append((viewController: viewController, completion: completion))
        pickImagesViewControllerCompletionClosure?(viewController, completion)
    }

}
class RouterProtocolMock: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?

    //MARK: - initialViewController

    var initialViewControllerCallsCount = 0
    var initialViewControllerCalled: Bool {
        return initialViewControllerCallsCount > 0
    }
    var initialViewControllerClosure: (() -> Void)?

    func initialViewController() {
        initialViewControllerCallsCount += 1
        initialViewControllerClosure?()
    }

    //MARK: - showBottomBar

    var showBottomBarCallsCount = 0
    var showBottomBarCalled: Bool {
        return showBottomBarCallsCount > 0
    }
    var showBottomBarClosure: (() -> Void)?

    func showBottomBar() {
        showBottomBarCallsCount += 1
        showBottomBarClosure?()
    }

    //MARK: - showChatList

    var showChatListCallsCount = 0
    var showChatListCalled: Bool {
        return showChatListCallsCount > 0
    }
    var showChatListClosure: (() -> Void)?

    func showChatList() {
        showChatListCallsCount += 1
        showChatListClosure?()
    }

    //MARK: - showChat

    var showChatCallsCount = 0
    var showChatCalled: Bool {
        return showChatCallsCount > 0
    }
    var showChatReceivedChatModel: ChatModel?
    var showChatReceivedInvocations: [ChatModel] = []
    var showChatClosure: ((ChatModel) -> Void)?

    func showChat(_ chatModel: ChatModel) {
        showChatCallsCount += 1
        showChatReceivedChatModel = chatModel
        showChatReceivedInvocations.append(chatModel)
        showChatClosure?(chatModel)
    }

    //MARK: - popToRoot

    var popToRootCallsCount = 0
    var popToRootCalled: Bool {
        return popToRootCallsCount > 0
    }
    var popToRootClosure: (() -> Void)?

    func popToRoot() {
        popToRootCallsCount += 1
        popToRootClosure?()
    }

}
class StorageServiceProtocolMock: StorageServiceProtocol {

    //MARK: - uploadImage

    var uploadImageChatDocumentIdImageTimestampIndexCompletionCallsCount = 0
    var uploadImageChatDocumentIdImageTimestampIndexCompletionCalled: Bool {
        return uploadImageChatDocumentIdImageTimestampIndexCompletionCallsCount > 0
    }
    var uploadImageChatDocumentIdImageTimestampIndexCompletionReceivedArguments: (chatDocumentId: String, image: UIImage, timestamp: Date, index: Int, completion: (MessageModel.MessageKind?) -> Void)?
    var uploadImageChatDocumentIdImageTimestampIndexCompletionReceivedInvocations: [(chatDocumentId: String, image: UIImage, timestamp: Date, index: Int, completion: (MessageModel.MessageKind?) -> Void)] = []
    var uploadImageChatDocumentIdImageTimestampIndexCompletionClosure: ((String, UIImage, Date, Int, @escaping (MessageModel.MessageKind?) -> Void) -> Void)?

    func uploadImage(        chatDocumentId: String,        image: UIImage,        timestamp: Date,        index: Int,        completion: @escaping (MessageModel.MessageKind?) -> Void    ) {
        uploadImageChatDocumentIdImageTimestampIndexCompletionCallsCount += 1
        uploadImageChatDocumentIdImageTimestampIndexCompletionReceivedArguments = (chatDocumentId: chatDocumentId, image: image, timestamp: timestamp, index: index, completion: completion)
        uploadImageChatDocumentIdImageTimestampIndexCompletionReceivedInvocations.append((chatDocumentId: chatDocumentId, image: image, timestamp: timestamp, index: index, completion: completion))
        uploadImageChatDocumentIdImageTimestampIndexCompletionClosure?(chatDocumentId, image, timestamp, index, completion)
    }

    //MARK: - listChatFiles

    var listChatFilesChatDocumentIdCompletionCallsCount = 0
    var listChatFilesChatDocumentIdCompletionCalled: Bool {
        return listChatFilesChatDocumentIdCompletionCallsCount > 0
    }
    var listChatFilesChatDocumentIdCompletionReceivedArguments: (chatDocumentId: String, completion: ([StorageReference]?) -> Void)?
    var listChatFilesChatDocumentIdCompletionReceivedInvocations: [(chatDocumentId: String, completion: ([StorageReference]?) -> Void)] = []
    var listChatFilesChatDocumentIdCompletionClosure: ((String, @escaping ([StorageReference]?) -> Void) -> Void)?

    func listChatFiles(        chatDocumentId: String,        completion: @escaping ([StorageReference]?) -> Void    ) {
        listChatFilesChatDocumentIdCompletionCallsCount += 1
        listChatFilesChatDocumentIdCompletionReceivedArguments = (chatDocumentId: chatDocumentId, completion: completion)
        listChatFilesChatDocumentIdCompletionReceivedInvocations.append((chatDocumentId: chatDocumentId, completion: completion))
        listChatFilesChatDocumentIdCompletionClosure?(chatDocumentId, completion)
    }

}
