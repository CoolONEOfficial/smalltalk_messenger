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

    //MARK: - presentErrorAlert

    var presentErrorAlertCallsCount = 0
    var presentErrorAlertCalled: Bool {
        return presentErrorAlertCallsCount > 0
    }
    var presentErrorAlertReceivedText: String?
    var presentErrorAlertReceivedInvocations: [String] = []
    var presentErrorAlertClosure: ((String) -> Void)?

    func presentErrorAlert(_ text: String) {
        presentErrorAlertCallsCount += 1
        presentErrorAlertReceivedText = text
        presentErrorAlertReceivedInvocations.append(text)
        presentErrorAlertClosure?(text)
    }

}
class ChatViewModelProtocolMock: ChatViewModelProtocol {
    var chatModel: ChatModel {
        get { return underlyingChatModel }
        set(value) { underlyingChatModel = value }
    }
    var underlyingChatModel: ChatModel!
    var lastTapCellContent: MessageCellContentProtocol!

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

    var sendMessageAttachmentsMessageTextCompletionCallsCount = 0
    var sendMessageAttachmentsMessageTextCompletionCalled: Bool {
        return sendMessageAttachmentsMessageTextCompletionCallsCount > 0
    }
    var sendMessageAttachmentsMessageTextCompletionReceivedArguments: (attachments: [ChatViewController.MessageAttachment], messageText: String?, completion: (Bool) -> Void)?
    var sendMessageAttachmentsMessageTextCompletionReceivedInvocations: [(attachments: [ChatViewController.MessageAttachment], messageText: String?, completion: (Bool) -> Void)] = []
    var sendMessageAttachmentsMessageTextCompletionClosure: (([ChatViewController.MessageAttachment], String?, @escaping (Bool) -> Void) -> Void)?

    func sendMessage(        attachments: [ChatViewController.MessageAttachment],        messageText: String?,        completion: @escaping (Bool) -> Void    ) {
        sendMessageAttachmentsMessageTextCompletionCallsCount += 1
        sendMessageAttachmentsMessageTextCompletionReceivedArguments = (attachments: attachments, messageText: messageText, completion: completion)
        sendMessageAttachmentsMessageTextCompletionReceivedInvocations.append((attachments: attachments, messageText: messageText, completion: completion))
        sendMessageAttachmentsMessageTextCompletionClosure?(attachments, messageText, completion)
    }

    //MARK: - forwardMessage

    var forwardMessageCompletionCallsCount = 0
    var forwardMessageCompletionCalled: Bool {
        return forwardMessageCompletionCallsCount > 0
    }
    var forwardMessageCompletionReceivedArguments: (chatModel: ChatModel, messageModel: MessageProtocol, completion: (Bool) -> Void)?
    var forwardMessageCompletionReceivedInvocations: [(chatModel: ChatModel, messageModel: MessageProtocol, completion: (Bool) -> Void)] = []
    var forwardMessageCompletionClosure: ((ChatModel, MessageProtocol, @escaping (Bool) -> Void) -> Void)?

    func forwardMessage(        _ chatModel: ChatModel,        _ messageModel: MessageProtocol,        completion: @escaping (Bool) -> Void    ) {
        forwardMessageCompletionCallsCount += 1
        forwardMessageCompletionReceivedArguments = (chatModel: chatModel, messageModel: messageModel, completion: completion)
        forwardMessageCompletionReceivedInvocations.append((chatModel: chatModel, messageModel: messageModel, completion: completion))
        forwardMessageCompletionClosure?(chatModel, messageModel, completion)
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

    //MARK: - deleteChat

    var deleteChatCompletionCallsCount = 0
    var deleteChatCompletionCalled: Bool {
        return deleteChatCompletionCallsCount > 0
    }
    var deleteChatCompletionReceivedCompletion: ((Bool) -> Void)?
    var deleteChatCompletionReceivedInvocations: [((Bool) -> Void)] = []
    var deleteChatCompletionClosure: ((@escaping (Bool) -> Void) -> Void)?

    func deleteChat(        completion: @escaping (Bool) -> Void    ) {
        deleteChatCompletionCallsCount += 1
        deleteChatCompletionReceivedCompletion = completion
        deleteChatCompletionReceivedInvocations.append(completion)
        deleteChatCompletionClosure?(completion)
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

    //MARK: - createForwardViewController

    var createForwardViewControllerForwardDelegateCallsCount = 0
    var createForwardViewControllerForwardDelegateCalled: Bool {
        return createForwardViewControllerForwardDelegateCallsCount > 0
    }
    var createForwardViewControllerForwardDelegateReceivedForwardDelegate: ForwardDelegateProtocol?
    var createForwardViewControllerForwardDelegateReceivedInvocations: [ForwardDelegateProtocol] = []
    var createForwardViewControllerForwardDelegateReturnValue: UIViewController!
    var createForwardViewControllerForwardDelegateClosure: ((ForwardDelegateProtocol) -> UIViewController)?

    func createForwardViewController(forwardDelegate: ForwardDelegateProtocol) -> UIViewController {
        createForwardViewControllerForwardDelegateCallsCount += 1
        createForwardViewControllerForwardDelegateReceivedForwardDelegate = forwardDelegate
        createForwardViewControllerForwardDelegateReceivedInvocations.append(forwardDelegate)
        return createForwardViewControllerForwardDelegateClosure.map({ $0(forwardDelegate) }) ?? createForwardViewControllerForwardDelegateReturnValue
    }

    //MARK: - goToChat

    var goToChatCallsCount = 0
    var goToChatCalled: Bool {
        return goToChatCallsCount > 0
    }
    var goToChatReceivedChatModel: ChatModel?
    var goToChatReceivedInvocations: [ChatModel] = []
    var goToChatClosure: ((ChatModel) -> Void)?

    func goToChat(        _ chatModel: ChatModel    ) {
        goToChatCallsCount += 1
        goToChatReceivedChatModel = chatModel
        goToChatReceivedInvocations.append(chatModel)
        goToChatClosure?(chatModel)
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

    //MARK: - didError

    var didErrorCallsCount = 0
    var didErrorCalled: Bool {
        return didErrorCallsCount > 0
    }
    var didErrorReceivedText: String?
    var didErrorReceivedInvocations: [String] = []
    var didErrorClosure: ((String) -> Void)?

    func didError(_ text: String) {
        didErrorCallsCount += 1
        didErrorReceivedText = text
        didErrorReceivedInvocations.append(text)
        didErrorClosure?(text)
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

    //MARK: - listChatMedia

    var listChatMediaChatDocumentIdCompletionCallsCount = 0
    var listChatMediaChatDocumentIdCompletionCalled: Bool {
        return listChatMediaChatDocumentIdCompletionCallsCount > 0
    }
    var listChatMediaChatDocumentIdCompletionReceivedArguments: (chatDocumentId: String, completion: ([MediaModel]?) -> Void)?
    var listChatMediaChatDocumentIdCompletionReceivedInvocations: [(chatDocumentId: String, completion: ([MediaModel]?) -> Void)] = []
    var listChatMediaChatDocumentIdCompletionClosure: ((String, @escaping ([MediaModel]?) -> Void) -> Void)?

    func listChatMedia(        chatDocumentId: String,        completion: @escaping ([MediaModel]?) -> Void    ) {
        listChatMediaChatDocumentIdCompletionCallsCount += 1
        listChatMediaChatDocumentIdCompletionReceivedArguments = (chatDocumentId: chatDocumentId, completion: completion)
        listChatMediaChatDocumentIdCompletionReceivedInvocations.append((chatDocumentId: chatDocumentId, completion: completion))
        listChatMediaChatDocumentIdCompletionClosure?(chatDocumentId, completion)
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

    //MARK: - uploadAudio

    var uploadAudioChatDocumentIdDataCompletionCallsCount = 0
    var uploadAudioChatDocumentIdDataCompletionCalled: Bool {
        return uploadAudioChatDocumentIdDataCompletionCallsCount > 0
    }
    var uploadAudioChatDocumentIdDataCompletionReceivedArguments: (chatDocumentId: String, data: Data, completion: (MessageModel.MessageKind?) -> Void)?
    var uploadAudioChatDocumentIdDataCompletionReceivedInvocations: [(chatDocumentId: String, data: Data, completion: (MessageModel.MessageKind?) -> Void)] = []
    var uploadAudioChatDocumentIdDataCompletionClosure: ((String, Data, @escaping (MessageModel.MessageKind?) -> Void) -> Void)?

    func uploadAudio(        chatDocumentId: String,        data: Data,        completion: @escaping (MessageModel.MessageKind?) -> Void    ) {
        uploadAudioChatDocumentIdDataCompletionCallsCount += 1
        uploadAudioChatDocumentIdDataCompletionReceivedArguments = (chatDocumentId: chatDocumentId, data: data, completion: completion)
        uploadAudioChatDocumentIdDataCompletionReceivedInvocations.append((chatDocumentId: chatDocumentId, data: data, completion: completion))
        uploadAudioChatDocumentIdDataCompletionClosure?(chatDocumentId, data, completion)
    }

}
