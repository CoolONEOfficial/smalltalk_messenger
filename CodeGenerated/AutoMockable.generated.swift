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














class AlgoliaServiceProtocolMock: AlgoliaServiceProtocol {

    //MARK: - searchChats

    var searchChatsCompletionCallsCount = 0
    var searchChatsCompletionCalled: Bool {
        return searchChatsCompletionCallsCount > 0
    }
    var searchChatsCompletionReceivedArguments: (searchString: String, completion: SearchChatsCompletion)?
    var searchChatsCompletionReceivedInvocations: [(searchString: String, completion: SearchChatsCompletion)] = []
    var searchChatsCompletionClosure: ((String, @escaping SearchChatsCompletion) -> Void)?

    func searchChats(_ searchString: String, completion: @escaping SearchChatsCompletion) {
        searchChatsCompletionCallsCount += 1
        searchChatsCompletionReceivedArguments = (searchString: searchString, completion: completion)
        searchChatsCompletionReceivedInvocations.append((searchString: searchString, completion: completion))
        searchChatsCompletionClosure?(searchString, completion)
    }

    //MARK: - searchMessages

    var searchMessagesCompletionCallsCount = 0
    var searchMessagesCompletionCalled: Bool {
        return searchMessagesCompletionCallsCount > 0
    }
    var searchMessagesCompletionReceivedArguments: (searchString: String, completion: SearchMessagesCompletion)?
    var searchMessagesCompletionReceivedInvocations: [(searchString: String, completion: SearchMessagesCompletion)] = []
    var searchMessagesCompletionClosure: ((String, @escaping SearchMessagesCompletion) -> Void)?

    func searchMessages(_ searchString: String, completion: @escaping SearchMessagesCompletion) {
        searchMessagesCompletionCallsCount += 1
        searchMessagesCompletionReceivedArguments = (searchString: searchString, completion: completion)
        searchMessagesCompletionReceivedInvocations.append((searchString: searchString, completion: completion))
        searchMessagesCompletionClosure?(searchString, completion)
    }

}
class ChatViewControllerProtocolMock: ChatViewControllerProtocol {
    var defaultTitle: String {
        get { return underlyingDefaultTitle }
        set(value) { underlyingDefaultTitle = value }
    }
    var underlyingDefaultTitle: String!
    var photosViewerDataSource: ChatPhotoViewerDataSource!

    //MARK: - present

    var presentAnimatedCompletionCallsCount = 0
    var presentAnimatedCompletionCalled: Bool {
        return presentAnimatedCompletionCallsCount > 0
    }
    var presentAnimatedCompletionReceivedArguments: (viewControllerToPresent: UIViewController, flag: Bool, completion: (() -> Void)?)?
    var presentAnimatedCompletionReceivedInvocations: [(viewControllerToPresent: UIViewController, flag: Bool, completion: (() -> Void)?)] = []
    var presentAnimatedCompletionClosure: ((UIViewController, Bool, (() -> Void)?) -> Void)?

    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        presentAnimatedCompletionCallsCount += 1
        presentAnimatedCompletionReceivedArguments = (viewControllerToPresent: viewControllerToPresent, flag: flag, completion: completion)
        presentAnimatedCompletionReceivedInvocations.append((viewControllerToPresent: viewControllerToPresent, flag: flag, completion: completion))
        presentAnimatedCompletionClosure?(viewControllerToPresent, flag, completion)
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

    //MARK: - didChatLoad

    var didChatLoadCallsCount = 0
    var didChatLoadCalled: Bool {
        return didChatLoadCallsCount > 0
    }
    var didChatLoadClosure: (() -> Void)?

    func didChatLoad() {
        didChatLoadCallsCount += 1
        didChatLoadClosure?()
    }

}
class ChatViewModelProtocolMock: ChatViewModelProtocol {
    var chat: ChatProtocol {
        get { return underlyingChat }
        set(value) { underlyingChat = value }
    }
    var underlyingChat: ChatProtocol!
    var baseQuery: FireQuery?
    var lastTapCellContent: MessageCellContentProtocol!

    //MARK: - sendMessage

    var sendMessageAttachmentsMessageTextCompletionCallsCount = 0
    var sendMessageAttachmentsMessageTextCompletionCalled: Bool {
        return sendMessageAttachmentsMessageTextCompletionCallsCount > 0
    }
    var sendMessageAttachmentsMessageTextCompletionReceivedArguments: (attachments: [ChatViewController.MessageAttachment], messageText: String?, completion: (Error?) -> Void)?
    var sendMessageAttachmentsMessageTextCompletionReceivedInvocations: [(attachments: [ChatViewController.MessageAttachment], messageText: String?, completion: (Error?) -> Void)] = []
    var sendMessageAttachmentsMessageTextCompletionClosure: (([ChatViewController.MessageAttachment], String?, @escaping (Error?) -> Void) -> Void)?

    func sendMessage(        attachments: [ChatViewController.MessageAttachment],        messageText: String?,        completion: @escaping (Error?) -> Void    ) {
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
    var forwardMessageCompletionReceivedArguments: (chatId: String, messageModel: MessageProtocol, completion: (Error?) -> Void)?
    var forwardMessageCompletionReceivedInvocations: [(chatId: String, messageModel: MessageProtocol, completion: (Error?) -> Void)] = []
    var forwardMessageCompletionClosure: ((String, MessageProtocol, @escaping (Error?) -> Void) -> Void)?

    func forwardMessage(        _ chatId: String,        _ messageModel: MessageProtocol,        completion: @escaping (Error?) -> Void    ) {
        forwardMessageCompletionCallsCount += 1
        forwardMessageCompletionReceivedArguments = (chatId: chatId, messageModel: messageModel, completion: completion)
        forwardMessageCompletionReceivedInvocations.append((chatId: chatId, messageModel: messageModel, completion: completion))
        forwardMessageCompletionClosure?(chatId, messageModel, completion)
    }

    //MARK: - deleteMessage

    var deleteMessageCompletionCallsCount = 0
    var deleteMessageCompletionCalled: Bool {
        return deleteMessageCompletionCallsCount > 0
    }
    var deleteMessageCompletionReceivedArguments: (messageModel: MessageProtocol, completion: (Error?) -> Void)?
    var deleteMessageCompletionReceivedInvocations: [(messageModel: MessageProtocol, completion: (Error?) -> Void)] = []
    var deleteMessageCompletionClosure: ((MessageProtocol, @escaping (Error?) -> Void) -> Void)?

    func deleteMessage(        _ messageModel: MessageProtocol,        completion: @escaping (Error?) -> Void    ) {
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
    var deleteChatCompletionReceivedCompletion: ((Error?) -> Void)?
    var deleteChatCompletionReceivedInvocations: [((Error?) -> Void)] = []
    var deleteChatCompletionClosure: ((@escaping (Error?) -> Void) -> Void)?

    func deleteChat(        completion: @escaping (Error?) -> Void    ) {
        deleteChatCompletionCallsCount += 1
        deleteChatCompletionReceivedCompletion = completion
        deleteChatCompletionReceivedInvocations.append(completion)
        deleteChatCompletionClosure?(completion)
    }

    //MARK: - createChat

    var createChatCompletionCallsCount = 0
    var createChatCompletionCalled: Bool {
        return createChatCompletionCallsCount > 0
    }
    var createChatCompletionReceivedCompletion: ((Error?) -> Void)?
    var createChatCompletionReceivedInvocations: [((Error?) -> Void)] = []
    var createChatCompletionClosure: ((@escaping (Error?) -> Void) -> Void)?

    func createChat(        completion: @escaping (Error?) -> Void    ) {
        createChatCompletionCallsCount += 1
        createChatCompletionReceivedCompletion = completion
        createChatCompletionReceivedInvocations.append(completion)
        createChatCompletionClosure?(completion)
    }

    //MARK: - presentForwardController

    var presentForwardControllerSelectDelegateCallsCount = 0
    var presentForwardControllerSelectDelegateCalled: Bool {
        return presentForwardControllerSelectDelegateCallsCount > 0
    }
    var presentForwardControllerSelectDelegateReceivedSelectDelegate: ChatSelectDelegate?
    var presentForwardControllerSelectDelegateReceivedInvocations: [ChatSelectDelegate] = []
    var presentForwardControllerSelectDelegateClosure: ((ChatSelectDelegate) -> Void)?

    func presentForwardController(        selectDelegate: ChatSelectDelegate    ) {
        presentForwardControllerSelectDelegateCallsCount += 1
        presentForwardControllerSelectDelegateReceivedSelectDelegate = selectDelegate
        presentForwardControllerSelectDelegateReceivedInvocations.append(selectDelegate)
        presentForwardControllerSelectDelegateClosure?(selectDelegate)
    }

    //MARK: - goToChat

    var goToChatCallsCount = 0
    var goToChatCalled: Bool {
        return goToChatCallsCount > 0
    }
    var goToChatReceivedChatId: String?
    var goToChatReceivedInvocations: [String] = []
    var goToChatClosure: ((String) -> Void)?

    func goToChat(        _ chatId: String    ) {
        goToChatCallsCount += 1
        goToChatReceivedChatId = chatId
        goToChatReceivedInvocations.append(chatId)
        goToChatClosure?(chatId)
    }

    //MARK: - listenUserListData

    var listenUserListDataCompletionCallsCount = 0
    var listenUserListDataCompletionCalled: Bool {
        return listenUserListDataCompletionCallsCount > 0
    }
    var listenUserListDataCompletionReceivedCompletion: (([UserModel]?) -> Void)?
    var listenUserListDataCompletionReceivedInvocations: [(([UserModel]?) -> Void)] = []
    var listenUserListDataCompletionClosure: ((@escaping ([UserModel]?) -> Void) -> Void)?

    func listenUserListData(        completion: @escaping ([UserModel]?) -> Void    ) {
        listenUserListDataCompletionCallsCount += 1
        listenUserListDataCompletionReceivedCompletion = completion
        listenUserListDataCompletionReceivedInvocations.append(completion)
        listenUserListDataCompletionClosure?(completion)
    }

    //MARK: - listenChatData

    var listenChatDataCompletionCallsCount = 0
    var listenChatDataCompletionCalled: Bool {
        return listenChatDataCompletionCallsCount > 0
    }
    var listenChatDataCompletionReceivedCompletion: ((ChatModel?) -> Void)?
    var listenChatDataCompletionReceivedInvocations: [((ChatModel?) -> Void)] = []
    var listenChatDataCompletionClosure: ((@escaping (ChatModel?) -> Void) -> Void)?

    func listenChatData(        completion: @escaping (ChatModel?) -> Void    ) {
        listenChatDataCompletionCallsCount += 1
        listenChatDataCompletionReceivedCompletion = completion
        listenChatDataCompletionReceivedInvocations.append(completion)
        listenChatDataCompletionClosure?(completion)
    }

    //MARK: - startTypingCurrentUser

    var startTypingCurrentUserCallsCount = 0
    var startTypingCurrentUserCalled: Bool {
        return startTypingCurrentUserCallsCount > 0
    }
    var startTypingCurrentUserClosure: (() -> Void)?

    func startTypingCurrentUser() {
        startTypingCurrentUserCallsCount += 1
        startTypingCurrentUserClosure?()
    }

    //MARK: - endTypingCurrentUser

    var endTypingCurrentUserCallsCount = 0
    var endTypingCurrentUserCalled: Bool {
        return endTypingCurrentUserCallsCount > 0
    }
    var endTypingCurrentUserClosure: (() -> Void)?

    func endTypingCurrentUser() {
        endTypingCurrentUserCallsCount += 1
        endTypingCurrentUserClosure?()
    }

    //MARK: - goToDetails

    var goToDetailsCallsCount = 0
    var goToDetailsCalled: Bool {
        return goToDetailsCallsCount > 0
    }
    var goToDetailsClosure: (() -> Void)?

    func goToDetails() {
        goToDetailsCallsCount += 1
        goToDetailsClosure?()
    }

    //MARK: - didAvatarTap

    var didAvatarTapCallsCount = 0
    var didAvatarTapCalled: Bool {
        return didAvatarTapCallsCount > 0
    }
    var didAvatarTapReceivedUserId: String?
    var didAvatarTapReceivedInvocations: [String] = []
    var didAvatarTapClosure: ((String) -> Void)?

    func didAvatarTap(_ userId: String) {
        didAvatarTapCallsCount += 1
        didAvatarTapReceivedUserId = userId
        didAvatarTapReceivedInvocations.append(userId)
        didAvatarTapClosure?(userId)
    }

    //MARK: - didContentTap

    var didContentTapCallsCount = 0
    var didContentTapCalled: Bool {
        return didContentTapCallsCount > 0
    }
    var didContentTapReceivedContent: MessageCellContentProtocol?
    var didContentTapReceivedInvocations: [MessageCellContentProtocol] = []
    var didContentTapClosure: ((MessageCellContentProtocol) -> Void)?

    func didContentTap(_ content: MessageCellContentProtocol) {
        didContentTapCallsCount += 1
        didContentTapReceivedContent = content
        didContentTapReceivedInvocations.append(content)
        didContentTapClosure?(content)
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

    //MARK: - cellUserData

    var cellUserDataCompletionCallsCount = 0
    var cellUserDataCompletionCalled: Bool {
        return cellUserDataCompletionCallsCount > 0
    }
    var cellUserDataCompletionReceivedArguments: (userId: String, completion: (UserModel?) -> Void)?
    var cellUserDataCompletionReceivedInvocations: [(userId: String, completion: (UserModel?) -> Void)] = []
    var cellUserDataCompletionClosure: ((String, @escaping (UserModel?) -> Void) -> Void)?

    func cellUserData(_ userId: String, completion: @escaping (UserModel?) -> Void) {
        cellUserDataCompletionCallsCount += 1
        cellUserDataCompletionReceivedArguments = (userId: userId, completion: completion)
        cellUserDataCompletionReceivedInvocations.append((userId: userId, completion: completion))
        cellUserDataCompletionClosure?(userId, completion)
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
    var contactListQuery: Query {
        get { return underlyingContactListQuery }
        set(value) { underlyingContactListQuery = value }
    }
    var underlyingContactListQuery: Query!
    var chatListQuery: Query {
        get { return underlyingChatListQuery }
        set(value) { underlyingChatListQuery = value }
    }
    var underlyingChatListQuery: Query!

    //MARK: - sendMessage

    var sendMessageChatIdMessageKindCompletionCallsCount = 0
    var sendMessageChatIdMessageKindCompletionCalled: Bool {
        return sendMessageChatIdMessageKindCompletionCallsCount > 0
    }
    var sendMessageChatIdMessageKindCompletionReceivedArguments: (chatId: String, messageKind: [MessageModel.MessageKind], completion: (Error?) -> Void)?
    var sendMessageChatIdMessageKindCompletionReceivedInvocations: [(chatId: String, messageKind: [MessageModel.MessageKind], completion: (Error?) -> Void)] = []
    var sendMessageChatIdMessageKindCompletionClosure: ((String, [MessageModel.MessageKind], @escaping (Error?) -> Void) -> Void)?

    func sendMessage(        chatId: String,        messageKind: [MessageModel.MessageKind],        completion: @escaping (Error?) -> Void    ) {
        sendMessageChatIdMessageKindCompletionCallsCount += 1
        sendMessageChatIdMessageKindCompletionReceivedArguments = (chatId: chatId, messageKind: messageKind, completion: completion)
        sendMessageChatIdMessageKindCompletionReceivedInvocations.append((chatId: chatId, messageKind: messageKind, completion: completion))
        sendMessageChatIdMessageKindCompletionClosure?(chatId, messageKind, completion)
    }

    //MARK: - deleteMessage

    var deleteMessageChatIdMessageDocumentIdCompletionCallsCount = 0
    var deleteMessageChatIdMessageDocumentIdCompletionCalled: Bool {
        return deleteMessageChatIdMessageDocumentIdCompletionCallsCount > 0
    }
    var deleteMessageChatIdMessageDocumentIdCompletionReceivedArguments: (chatId: String, messageDocumentId: String, completion: (Error?) -> Void)?
    var deleteMessageChatIdMessageDocumentIdCompletionReceivedInvocations: [(chatId: String, messageDocumentId: String, completion: (Error?) -> Void)] = []
    var deleteMessageChatIdMessageDocumentIdCompletionClosure: ((String, String, @escaping (Error?) -> Void) -> Void)?

    func deleteMessage(        chatId: String,        messageDocumentId: String,        completion: @escaping (Error?) -> Void    ) {
        deleteMessageChatIdMessageDocumentIdCompletionCallsCount += 1
        deleteMessageChatIdMessageDocumentIdCompletionReceivedArguments = (chatId: chatId, messageDocumentId: messageDocumentId, completion: completion)
        deleteMessageChatIdMessageDocumentIdCompletionReceivedInvocations.append((chatId: chatId, messageDocumentId: messageDocumentId, completion: completion))
        deleteMessageChatIdMessageDocumentIdCompletionClosure?(chatId, messageDocumentId, completion)
    }

    //MARK: - deleteChat

    var deleteChatChatCompletionCallsCount = 0
    var deleteChatChatCompletionCalled: Bool {
        return deleteChatChatCompletionCallsCount > 0
    }
    var deleteChatChatCompletionReceivedArguments: (chat: ChatProtocol, completion: (Error?) -> Void)?
    var deleteChatChatCompletionReceivedInvocations: [(chat: ChatProtocol, completion: (Error?) -> Void)] = []
    var deleteChatChatCompletionClosure: ((ChatProtocol, @escaping (Error?) -> Void) -> Void)?

    func deleteChat(        chat: ChatProtocol,        completion: @escaping (Error?) -> Void    ) {
        deleteChatChatCompletionCallsCount += 1
        deleteChatChatCompletionReceivedArguments = (chat: chat, completion: completion)
        deleteChatChatCompletionReceivedInvocations.append((chat: chat, completion: completion))
        deleteChatChatCompletionClosure?(chat, completion)
    }

    //MARK: - updateChat

    var updateChatCompletionCallsCount = 0
    var updateChatCompletionCalled: Bool {
        return updateChatCompletionCallsCount > 0
    }
    var updateChatCompletionReceivedArguments: (chatModel: ChatModel, completion: (Error?) -> Void)?
    var updateChatCompletionReceivedInvocations: [(chatModel: ChatModel, completion: (Error?) -> Void)] = []
    var updateChatCompletionClosure: ((ChatModel, @escaping (Error?) -> Void) -> Void)?

    func updateChat(        _ chatModel: ChatModel,        completion: @escaping (Error?) -> Void    ) {
        updateChatCompletionCallsCount += 1
        updateChatCompletionReceivedArguments = (chatModel: chatModel, completion: completion)
        updateChatCompletionReceivedInvocations.append((chatModel: chatModel, completion: completion))
        updateChatCompletionClosure?(chatModel, completion)
    }

    //MARK: - kickChatUser

    var kickChatUserChatIdUserIdCompletionCallsCount = 0
    var kickChatUserChatIdUserIdCompletionCalled: Bool {
        return kickChatUserChatIdUserIdCompletionCallsCount > 0
    }
    var kickChatUserChatIdUserIdCompletionReceivedArguments: (chatId: String, userId: String, completion: (Error?) -> Void)?
    var kickChatUserChatIdUserIdCompletionReceivedInvocations: [(chatId: String, userId: String, completion: (Error?) -> Void)] = []
    var kickChatUserChatIdUserIdCompletionClosure: ((String, String, @escaping (Error?) -> Void) -> Void)?

    func kickChatUser(        chatId: String,        userId: String,        completion: @escaping (Error?) -> Void    ) {
        kickChatUserChatIdUserIdCompletionCallsCount += 1
        kickChatUserChatIdUserIdCompletionReceivedArguments = (chatId: chatId, userId: userId, completion: completion)
        kickChatUserChatIdUserIdCompletionReceivedInvocations.append((chatId: chatId, userId: userId, completion: completion))
        kickChatUserChatIdUserIdCompletionClosure?(chatId, userId, completion)
    }

    //MARK: - inviteChatUser

    var inviteChatUserChatIdUserIdCompletionCallsCount = 0
    var inviteChatUserChatIdUserIdCompletionCalled: Bool {
        return inviteChatUserChatIdUserIdCompletionCallsCount > 0
    }
    var inviteChatUserChatIdUserIdCompletionReceivedArguments: (chatId: String, userId: String, completion: (Error?) -> Void)?
    var inviteChatUserChatIdUserIdCompletionReceivedInvocations: [(chatId: String, userId: String, completion: (Error?) -> Void)] = []
    var inviteChatUserChatIdUserIdCompletionClosure: ((String, String, @escaping (Error?) -> Void) -> Void)?

    func inviteChatUser(        chatId: String,        userId: String,        completion: @escaping (Error?) -> Void    ) {
        inviteChatUserChatIdUserIdCompletionCallsCount += 1
        inviteChatUserChatIdUserIdCompletionReceivedArguments = (chatId: chatId, userId: userId, completion: completion)
        inviteChatUserChatIdUserIdCompletionReceivedInvocations.append((chatId: chatId, userId: userId, completion: completion))
        inviteChatUserChatIdUserIdCompletionClosure?(chatId, userId, completion)
    }

    //MARK: - listChatMedia

    var listChatMediaChatIdCompletionCallsCount = 0
    var listChatMediaChatIdCompletionCalled: Bool {
        return listChatMediaChatIdCompletionCallsCount > 0
    }
    var listChatMediaChatIdCompletionReceivedArguments: (chatId: String, completion: ([MediaModel]?) -> Void)?
    var listChatMediaChatIdCompletionReceivedInvocations: [(chatId: String, completion: ([MediaModel]?) -> Void)] = []
    var listChatMediaChatIdCompletionClosure: ((String, @escaping ([MediaModel]?) -> Void) -> Void)?

    func listChatMedia(        chatId: String,        completion: @escaping ([MediaModel]?) -> Void    ) {
        listChatMediaChatIdCompletionCallsCount += 1
        listChatMediaChatIdCompletionReceivedArguments = (chatId: chatId, completion: completion)
        listChatMediaChatIdCompletionReceivedInvocations.append((chatId: chatId, completion: completion))
        listChatMediaChatIdCompletionClosure?(chatId, completion)
    }

    //MARK: - getChatData

    var getChatDataCompletionCallsCount = 0
    var getChatDataCompletionCalled: Bool {
        return getChatDataCompletionCallsCount > 0
    }
    var getChatDataCompletionReceivedArguments: (chatId: String, completion: (ChatModel?) -> Void)?
    var getChatDataCompletionReceivedInvocations: [(chatId: String, completion: (ChatModel?) -> Void)] = []
    var getChatDataCompletionClosure: ((String, @escaping (ChatModel?) -> Void) -> Void)?

    func getChatData(        _ chatId: String,        completion: @escaping (ChatModel?) -> Void    ) {
        getChatDataCompletionCallsCount += 1
        getChatDataCompletionReceivedArguments = (chatId: chatId, completion: completion)
        getChatDataCompletionReceivedInvocations.append((chatId: chatId, completion: completion))
        getChatDataCompletionClosure?(chatId, completion)
    }

    //MARK: - listenChatData

    var listenChatDataCompletionCallsCount = 0
    var listenChatDataCompletionCalled: Bool {
        return listenChatDataCompletionCallsCount > 0
    }
    var listenChatDataCompletionReceivedArguments: (chatId: String, completion: (ChatModel?) -> Void)?
    var listenChatDataCompletionReceivedInvocations: [(chatId: String, completion: (ChatModel?) -> Void)] = []
    var listenChatDataCompletionClosure: ((String, @escaping (ChatModel?) -> Void) -> Void)?

    func listenChatData(        _ chatId: String,        completion: @escaping (ChatModel?) -> Void    ) {
        listenChatDataCompletionCallsCount += 1
        listenChatDataCompletionReceivedArguments = (chatId: chatId, completion: completion)
        listenChatDataCompletionReceivedInvocations.append((chatId: chatId, completion: completion))
        listenChatDataCompletionClosure?(chatId, completion)
    }

    //MARK: - getChatData

    var getChatDataUserIdCompletionCallsCount = 0
    var getChatDataUserIdCompletionCalled: Bool {
        return getChatDataUserIdCompletionCallsCount > 0
    }
    var getChatDataUserIdCompletionReceivedArguments: (userId: String, completion: (ChatModel?) -> Void)?
    var getChatDataUserIdCompletionReceivedInvocations: [(userId: String, completion: (ChatModel?) -> Void)] = []
    var getChatDataUserIdCompletionClosure: ((String, @escaping (ChatModel?) -> Void) -> Void)?

    func getChatData(        userId: String,        completion: @escaping (ChatModel?) -> Void    ) {
        getChatDataUserIdCompletionCallsCount += 1
        getChatDataUserIdCompletionReceivedArguments = (userId: userId, completion: completion)
        getChatDataUserIdCompletionReceivedInvocations.append((userId: userId, completion: completion))
        getChatDataUserIdCompletionClosure?(userId, completion)
    }

    //MARK: - listenChatData

    var listenChatDataUserIdCompletionCallsCount = 0
    var listenChatDataUserIdCompletionCalled: Bool {
        return listenChatDataUserIdCompletionCallsCount > 0
    }
    var listenChatDataUserIdCompletionReceivedArguments: (userId: String, completion: (ChatModel?) -> Void)?
    var listenChatDataUserIdCompletionReceivedInvocations: [(userId: String, completion: (ChatModel?) -> Void)] = []
    var listenChatDataUserIdCompletionClosure: ((String, @escaping (ChatModel?) -> Void) -> Void)?

    func listenChatData(        userId: String,        completion: @escaping (ChatModel?) -> Void    ) {
        listenChatDataUserIdCompletionCallsCount += 1
        listenChatDataUserIdCompletionReceivedArguments = (userId: userId, completion: completion)
        listenChatDataUserIdCompletionReceivedInvocations.append((userId: userId, completion: completion))
        listenChatDataUserIdCompletionClosure?(userId, completion)
    }

    //MARK: - createChat

    var createChatAvatarTimestampCompletionCallsCount = 0
    var createChatAvatarTimestampCompletionCalled: Bool {
        return createChatAvatarTimestampCompletionCallsCount > 0
    }
    var createChatAvatarTimestampCompletionReceivedArguments: (chatModel: ChatModel, avatarTimestamp: Date?, completion: (Error?) -> Void)?
    var createChatAvatarTimestampCompletionReceivedInvocations: [(chatModel: ChatModel, avatarTimestamp: Date?, completion: (Error?) -> Void)] = []
    var createChatAvatarTimestampCompletionReturnValue: String!
    var createChatAvatarTimestampCompletionClosure: ((ChatModel, Date?, @escaping (Error?) -> Void) -> String)?

    func createChat(        _ chatModel: ChatModel,        avatarTimestamp: Date?,        completion: @escaping (Error?) -> Void    ) -> String {
        createChatAvatarTimestampCompletionCallsCount += 1
        createChatAvatarTimestampCompletionReceivedArguments = (chatModel: chatModel, avatarTimestamp: avatarTimestamp, completion: completion)
        createChatAvatarTimestampCompletionReceivedInvocations.append((chatModel: chatModel, avatarTimestamp: avatarTimestamp, completion: completion))
        return createChatAvatarTimestampCompletionClosure.map({ $0(chatModel, avatarTimestamp, completion) }) ?? createChatAvatarTimestampCompletionReturnValue
    }

    //MARK: - createContact

    var createContactCompletionCallsCount = 0
    var createContactCompletionCalled: Bool {
        return createContactCompletionCallsCount > 0
    }
    var createContactCompletionReceivedArguments: (contactModel: ContactModel, completion: (Error?) -> Void)?
    var createContactCompletionReceivedInvocations: [(contactModel: ContactModel, completion: (Error?) -> Void)] = []
    var createContactCompletionClosure: ((ContactModel, @escaping (Error?) -> Void) -> Void)?

    func createContact(        _ contactModel: ContactModel,        completion: @escaping (Error?) -> Void    ) {
        createContactCompletionCallsCount += 1
        createContactCompletionReceivedArguments = (contactModel: contactModel, completion: completion)
        createContactCompletionReceivedInvocations.append((contactModel: contactModel, completion: completion))
        createContactCompletionClosure?(contactModel, completion)
    }

    //MARK: - deleteContact

    var deleteContactCompletionCallsCount = 0
    var deleteContactCompletionCalled: Bool {
        return deleteContactCompletionCallsCount > 0
    }
    var deleteContactCompletionReceivedArguments: (contactId: String, completion: (Error?) -> Void)?
    var deleteContactCompletionReceivedInvocations: [(contactId: String, completion: (Error?) -> Void)] = []
    var deleteContactCompletionClosure: ((String, @escaping (Error?) -> Void) -> Void)?

    func deleteContact(        _ contactId: String,        completion: @escaping (Error?) -> Void    ) {
        deleteContactCompletionCallsCount += 1
        deleteContactCompletionReceivedArguments = (contactId: contactId, completion: completion)
        deleteContactCompletionReceivedInvocations.append((contactId: contactId, completion: completion))
        deleteContactCompletionClosure?(contactId, completion)
    }

    //MARK: - getContact

    var getContactCompletionCallsCount = 0
    var getContactCompletionCalled: Bool {
        return getContactCompletionCallsCount > 0
    }
    var getContactCompletionReceivedArguments: (userId: String, completion: (ContactModel?, Error?) -> Void)?
    var getContactCompletionReceivedInvocations: [(userId: String, completion: (ContactModel?, Error?) -> Void)] = []
    var getContactCompletionClosure: ((String, @escaping (ContactModel?, Error?) -> Void) -> Void)?

    func getContact(        _ userId: String,        completion: @escaping (ContactModel?, Error?) -> Void    ) {
        getContactCompletionCallsCount += 1
        getContactCompletionReceivedArguments = (userId: userId, completion: completion)
        getContactCompletionReceivedInvocations.append((userId: userId, completion: completion))
        getContactCompletionClosure?(userId, completion)
    }

    //MARK: - createUser

    var createUserAvatarTimestampCompletionCallsCount = 0
    var createUserAvatarTimestampCompletionCalled: Bool {
        return createUserAvatarTimestampCompletionCallsCount > 0
    }
    var createUserAvatarTimestampCompletionReceivedArguments: (userModel: UserModel, avatarTimestamp: Date?, completion: (Error?) -> Void)?
    var createUserAvatarTimestampCompletionReceivedInvocations: [(userModel: UserModel, avatarTimestamp: Date?, completion: (Error?) -> Void)] = []
    var createUserAvatarTimestampCompletionReturnValue: String!
    var createUserAvatarTimestampCompletionClosure: ((UserModel, Date?, @escaping (Error?) -> Void) -> String)?

    func createUser(        _ userModel: UserModel,        avatarTimestamp: Date?,        completion: @escaping (Error?) -> Void    ) -> String {
        createUserAvatarTimestampCompletionCallsCount += 1
        createUserAvatarTimestampCompletionReceivedArguments = (userModel: userModel, avatarTimestamp: avatarTimestamp, completion: completion)
        createUserAvatarTimestampCompletionReceivedInvocations.append((userModel: userModel, avatarTimestamp: avatarTimestamp, completion: completion))
        return createUserAvatarTimestampCompletionClosure.map({ $0(userModel, avatarTimestamp, completion) }) ?? createUserAvatarTimestampCompletionReturnValue
    }

    //MARK: - listenCurrentUserData

    var listenCurrentUserDataCompletionCallsCount = 0
    var listenCurrentUserDataCompletionCalled: Bool {
        return listenCurrentUserDataCompletionCallsCount > 0
    }
    var listenCurrentUserDataCompletionReceivedCompletion: ((UserModel?) -> Void)?
    var listenCurrentUserDataCompletionReceivedInvocations: [((UserModel?) -> Void)] = []
    var listenCurrentUserDataCompletionClosure: ((@escaping (UserModel?) -> Void) -> Void)?

    func listenCurrentUserData(        completion: @escaping (UserModel?) -> Void    ) {
        listenCurrentUserDataCompletionCallsCount += 1
        listenCurrentUserDataCompletionReceivedCompletion = completion
        listenCurrentUserDataCompletionReceivedInvocations.append(completion)
        listenCurrentUserDataCompletionClosure?(completion)
    }

    //MARK: - listenUserData

    var listenUserDataCompletionCallsCount = 0
    var listenUserDataCompletionCalled: Bool {
        return listenUserDataCompletionCallsCount > 0
    }
    var listenUserDataCompletionReceivedArguments: (userId: String, completion: (UserModel?) -> Void)?
    var listenUserDataCompletionReceivedInvocations: [(userId: String, completion: (UserModel?) -> Void)] = []
    var listenUserDataCompletionClosure: ((String, @escaping (UserModel?) -> Void) -> Void)?

    func listenUserData(        _ userId: String,        completion: @escaping (UserModel?) -> Void    ) {
        listenUserDataCompletionCallsCount += 1
        listenUserDataCompletionReceivedArguments = (userId: userId, completion: completion)
        listenUserDataCompletionReceivedInvocations.append((userId: userId, completion: completion))
        listenUserDataCompletionClosure?(userId, completion)
    }

    //MARK: - getUserData

    var getUserDataCompletionCallsCount = 0
    var getUserDataCompletionCalled: Bool {
        return getUserDataCompletionCallsCount > 0
    }
    var getUserDataCompletionReceivedArguments: (userId: String, completion: (UserModel?) -> Void)?
    var getUserDataCompletionReceivedInvocations: [(userId: String, completion: (UserModel?) -> Void)] = []
    var getUserDataCompletionClosure: ((String, @escaping (UserModel?) -> Void) -> Void)?

    func getUserData(        _ userId: String,        completion: @escaping (UserModel?) -> Void    ) {
        getUserDataCompletionCallsCount += 1
        getUserDataCompletionReceivedArguments = (userId: userId, completion: completion)
        getUserDataCompletionReceivedInvocations.append((userId: userId, completion: completion))
        getUserDataCompletionClosure?(userId, completion)
    }

    //MARK: - listenUserListData

    var listenUserListDataCompletionCallsCount = 0
    var listenUserListDataCompletionCalled: Bool {
        return listenUserListDataCompletionCallsCount > 0
    }
    var listenUserListDataCompletionReceivedArguments: (userList: [String], completion: ([UserModel]?) -> Void)?
    var listenUserListDataCompletionReceivedInvocations: [(userList: [String], completion: ([UserModel]?) -> Void)] = []
    var listenUserListDataCompletionClosure: (([String], @escaping ([UserModel]?) -> Void) -> Void)?

    func listenUserListData(        _ userList: [String],        completion: @escaping ([UserModel]?) -> Void    ) {
        listenUserListDataCompletionCallsCount += 1
        listenUserListDataCompletionReceivedArguments = (userList: userList, completion: completion)
        listenUserListDataCompletionReceivedInvocations.append((userList: userList, completion: completion))
        listenUserListDataCompletionClosure?(userList, completion)
    }

    //MARK: - searchUsers

    var searchUsersByCompletionCallsCount = 0
    var searchUsersByCompletionCalled: Bool {
        return searchUsersByCompletionCallsCount > 0
    }
    var searchUsersByCompletionReceivedArguments: (phoneNumbers: [String], completion: ([UserModel]?, Bool) -> Void)?
    var searchUsersByCompletionReceivedInvocations: [(phoneNumbers: [String], completion: ([UserModel]?, Bool) -> Void)] = []
    var searchUsersByCompletionClosure: (([String], @escaping ([UserModel]?, Bool) -> Void) -> Void)?

    func searchUsers(        by phoneNumbers: [String],        completion: @escaping ([UserModel]?, Bool) -> Void    ) {
        searchUsersByCompletionCallsCount += 1
        searchUsersByCompletionReceivedArguments = (phoneNumbers: phoneNumbers, completion: completion)
        searchUsersByCompletionReceivedInvocations.append((phoneNumbers: phoneNumbers, completion: completion))
        searchUsersByCompletionClosure?(phoneNumbers, completion)
    }

    //MARK: - onlineCurrentUser

    var onlineCurrentUserCallsCount = 0
    var onlineCurrentUserCalled: Bool {
        return onlineCurrentUserCallsCount > 0
    }
    var onlineCurrentUserClosure: (() -> Void)?

    func onlineCurrentUser() {
        onlineCurrentUserCallsCount += 1
        onlineCurrentUserClosure?()
    }

    //MARK: - offlineCurrentUser

    var offlineCurrentUserCallsCount = 0
    var offlineCurrentUserCalled: Bool {
        return offlineCurrentUserCallsCount > 0
    }
    var offlineCurrentUserClosure: (() -> Void)?

    func offlineCurrentUser() {
        offlineCurrentUserCallsCount += 1
        offlineCurrentUserClosure?()
    }

    //MARK: - startTypingCurrentUser

    var startTypingCurrentUserCallsCount = 0
    var startTypingCurrentUserCalled: Bool {
        return startTypingCurrentUserCallsCount > 0
    }
    var startTypingCurrentUserReceivedChatId: String?
    var startTypingCurrentUserReceivedInvocations: [String] = []
    var startTypingCurrentUserClosure: ((String) -> Void)?

    func startTypingCurrentUser(_ chatId: String) {
        startTypingCurrentUserCallsCount += 1
        startTypingCurrentUserReceivedChatId = chatId
        startTypingCurrentUserReceivedInvocations.append(chatId)
        startTypingCurrentUserClosure?(chatId)
    }

    //MARK: - endTypingCurrentUser

    var endTypingCurrentUserCallsCount = 0
    var endTypingCurrentUserCalled: Bool {
        return endTypingCurrentUserCallsCount > 0
    }
    var endTypingCurrentUserClosure: (() -> Void)?

    func endTypingCurrentUser() {
        endTypingCurrentUserCallsCount += 1
        endTypingCurrentUserClosure?()
    }

    //MARK: - chatBaseQuery

    var chatBaseQueryCallsCount = 0
    var chatBaseQueryCalled: Bool {
        return chatBaseQueryCallsCount > 0
    }
    var chatBaseQueryReceivedChatId: String?
    var chatBaseQueryReceivedInvocations: [String] = []
    var chatBaseQueryReturnValue: FireQuery!
    var chatBaseQueryClosure: ((String) -> FireQuery)?

    func chatBaseQuery(_ chatId: String) -> FireQuery {
        chatBaseQueryCallsCount += 1
        chatBaseQueryReceivedChatId = chatId
        chatBaseQueryReceivedInvocations.append(chatId)
        return chatBaseQueryClosure.map({ $0(chatId) }) ?? chatBaseQueryReturnValue
    }

}
class ImagePickerServiceProtocolMock: ImagePickerServiceProtocol {

    //MARK: - pickPhotos

    var pickPhotosCompletionCallsCount = 0
    var pickPhotosCompletionCalled: Bool {
        return pickPhotosCompletionCallsCount > 0
    }
    var pickPhotosCompletionReceivedCompletion: (ImageCompletion)?
    var pickPhotosCompletionReceivedInvocations: [(ImageCompletion)] = []
    var pickPhotosCompletionClosure: ((@escaping ImageCompletion) -> Void)?

    func pickPhotos(completion: @escaping ImageCompletion) {
        pickPhotosCompletionCallsCount += 1
        pickPhotosCompletionReceivedCompletion = completion
        pickPhotosCompletionReceivedInvocations.append(completion)
        pickPhotosCompletionClosure?(completion)
    }

    //MARK: - pickSinglePhoto

    var pickSinglePhotoCompletionCallsCount = 0
    var pickSinglePhotoCompletionCalled: Bool {
        return pickSinglePhotoCompletionCallsCount > 0
    }
    var pickSinglePhotoCompletionReceivedCompletion: (ImageCompletion)?
    var pickSinglePhotoCompletionReceivedInvocations: [(ImageCompletion)] = []
    var pickSinglePhotoCompletionClosure: ((@escaping ImageCompletion) -> Void)?

    func pickSinglePhoto(completion: @escaping ImageCompletion) {
        pickSinglePhotoCompletionCallsCount += 1
        pickSinglePhotoCompletionReceivedCompletion = completion
        pickSinglePhotoCompletionReceivedInvocations.append(completion)
        pickSinglePhotoCompletionClosure?(completion)
    }

    //MARK: - pickCamera

    var pickCameraCompletionDeviceCallsCount = 0
    var pickCameraCompletionDeviceCalled: Bool {
        return pickCameraCompletionDeviceCallsCount > 0
    }
    var pickCameraCompletionDeviceReceivedArguments: (completion: ImageCompletion, device: UIImagePickerController.CameraDevice?)?
    var pickCameraCompletionDeviceReceivedInvocations: [(completion: ImageCompletion, device: UIImagePickerController.CameraDevice?)] = []
    var pickCameraCompletionDeviceClosure: ((@escaping ImageCompletion, UIImagePickerController.CameraDevice?) -> Void)?

    func pickCamera(completion: @escaping ImageCompletion, device: UIImagePickerController.CameraDevice?) {
        pickCameraCompletionDeviceCallsCount += 1
        pickCameraCompletionDeviceReceivedArguments = (completion: completion, device: device)
        pickCameraCompletionDeviceReceivedInvocations.append((completion: completion, device: device))
        pickCameraCompletionDeviceClosure?(completion, device)
    }

    //MARK: - showPickDialog

    var showPickDialogModeCompletionCallsCount = 0
    var showPickDialogModeCompletionCalled: Bool {
        return showPickDialogModeCompletionCallsCount > 0
    }
    var showPickDialogModeCompletionReceivedArguments: (mode: ImagePickerDialog.Mode, completion: ImageCompletion)?
    var showPickDialogModeCompletionReceivedInvocations: [(mode: ImagePickerDialog.Mode, completion: ImageCompletion)] = []
    var showPickDialogModeCompletionClosure: ((ImagePickerDialog.Mode, @escaping ImageCompletion) -> Void)?

    func showPickDialog(mode: ImagePickerDialog.Mode, completion: @escaping ImageCompletion) {
        showPickDialogModeCompletionCallsCount += 1
        showPickDialogModeCompletionReceivedArguments = (mode: mode, completion: completion)
        showPickDialogModeCompletionReceivedInvocations.append((mode: mode, completion: completion))
        showPickDialogModeCompletionClosure?(mode, completion)
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

    //MARK: - showContactsList

    var showContactsListCallsCount = 0
    var showContactsListCalled: Bool {
        return showContactsListCallsCount > 0
    }
    var showContactsListClosure: (() -> Void)?

    func showContactsList() {
        showContactsListCallsCount += 1
        showContactsListClosure?()
    }

    //MARK: - showUserPicker

    var showUserPickerSelectDelegateCallsCount = 0
    var showUserPickerSelectDelegateCalled: Bool {
        return showUserPickerSelectDelegateCallsCount > 0
    }
    var showUserPickerSelectDelegateReceivedSelectDelegate: ContactsSelectDelegate?
    var showUserPickerSelectDelegateReceivedInvocations: [ContactsSelectDelegate] = []
    var showUserPickerSelectDelegateClosure: ((ContactsSelectDelegate) -> Void)?

    func showUserPicker(selectDelegate: ContactsSelectDelegate) {
        showUserPickerSelectDelegateCallsCount += 1
        showUserPickerSelectDelegateReceivedSelectDelegate = selectDelegate
        showUserPickerSelectDelegateReceivedInvocations.append(selectDelegate)
        showUserPickerSelectDelegateClosure?(selectDelegate)
    }

}
class StorageServiceProtocolMock: StorageServiceProtocol {

    //MARK: - uploadUserAvatar

    var uploadUserAvatarUserIdAvatarTimestampCompletionCallsCount = 0
    var uploadUserAvatarUserIdAvatarTimestampCompletionCalled: Bool {
        return uploadUserAvatarUserIdAvatarTimestampCompletionCallsCount > 0
    }
    var uploadUserAvatarUserIdAvatarTimestampCompletionReceivedArguments: (userId: String, avatar: UIImage, timestamp: Date, completion: ((path: String, size: ImageSize)?, Error?) -> Void)?
    var uploadUserAvatarUserIdAvatarTimestampCompletionReceivedInvocations: [(userId: String, avatar: UIImage, timestamp: Date, completion: ((path: String, size: ImageSize)?, Error?) -> Void)] = []
    var uploadUserAvatarUserIdAvatarTimestampCompletionClosure: ((String, UIImage, Date, @escaping ((path: String, size: ImageSize)?, Error?) -> Void) -> Void)?

    func uploadUserAvatar(        userId: String,        avatar: UIImage,        timestamp: Date,        completion: @escaping ((path: String, size: ImageSize)?, Error?) -> Void    ) {
        uploadUserAvatarUserIdAvatarTimestampCompletionCallsCount += 1
        uploadUserAvatarUserIdAvatarTimestampCompletionReceivedArguments = (userId: userId, avatar: avatar, timestamp: timestamp, completion: completion)
        uploadUserAvatarUserIdAvatarTimestampCompletionReceivedInvocations.append((userId: userId, avatar: avatar, timestamp: timestamp, completion: completion))
        uploadUserAvatarUserIdAvatarTimestampCompletionClosure?(userId, avatar, timestamp, completion)
    }

    //MARK: - uploadChatAvatar

    var uploadChatAvatarChatIdAvatarTimestampCompletionCallsCount = 0
    var uploadChatAvatarChatIdAvatarTimestampCompletionCalled: Bool {
        return uploadChatAvatarChatIdAvatarTimestampCompletionCallsCount > 0
    }
    var uploadChatAvatarChatIdAvatarTimestampCompletionReceivedArguments: (chatId: String, avatar: UIImage, timestamp: Date, completion: ((path: String, size: ImageSize)?, Error?) -> Void)?
    var uploadChatAvatarChatIdAvatarTimestampCompletionReceivedInvocations: [(chatId: String, avatar: UIImage, timestamp: Date, completion: ((path: String, size: ImageSize)?, Error?) -> Void)] = []
    var uploadChatAvatarChatIdAvatarTimestampCompletionClosure: ((String, UIImage, Date, @escaping ((path: String, size: ImageSize)?, Error?) -> Void) -> Void)?

    func uploadChatAvatar(        chatId: String,        avatar: UIImage,        timestamp: Date,        completion: @escaping ((path: String, size: ImageSize)?, Error?) -> Void    ) {
        uploadChatAvatarChatIdAvatarTimestampCompletionCallsCount += 1
        uploadChatAvatarChatIdAvatarTimestampCompletionReceivedArguments = (chatId: chatId, avatar: avatar, timestamp: timestamp, completion: completion)
        uploadChatAvatarChatIdAvatarTimestampCompletionReceivedInvocations.append((chatId: chatId, avatar: avatar, timestamp: timestamp, completion: completion))
        uploadChatAvatarChatIdAvatarTimestampCompletionClosure?(chatId, avatar, timestamp, completion)
    }

    //MARK: - uploadImage

    var uploadImageChatIdImageTimestampIndexCompletionCallsCount = 0
    var uploadImageChatIdImageTimestampIndexCompletionCalled: Bool {
        return uploadImageChatIdImageTimestampIndexCompletionCallsCount > 0
    }
    var uploadImageChatIdImageTimestampIndexCompletionReceivedArguments: (chatId: String, image: UIImage, timestamp: Date, index: Int, completion: ((path: String, size: ImageSize)?, Error?) -> Void)?
    var uploadImageChatIdImageTimestampIndexCompletionReceivedInvocations: [(chatId: String, image: UIImage, timestamp: Date, index: Int, completion: ((path: String, size: ImageSize)?, Error?) -> Void)] = []
    var uploadImageChatIdImageTimestampIndexCompletionClosure: ((String, UIImage, Date, Int, @escaping ((path: String, size: ImageSize)?, Error?) -> Void) -> Void)?

    func uploadImage(        chatId: String,        image: UIImage,        timestamp: Date,        index: Int,        completion: @escaping ((path: String, size: ImageSize)?, Error?) -> Void    ) {
        uploadImageChatIdImageTimestampIndexCompletionCallsCount += 1
        uploadImageChatIdImageTimestampIndexCompletionReceivedArguments = (chatId: chatId, image: image, timestamp: timestamp, index: index, completion: completion)
        uploadImageChatIdImageTimestampIndexCompletionReceivedInvocations.append((chatId: chatId, image: image, timestamp: timestamp, index: index, completion: completion))
        uploadImageChatIdImageTimestampIndexCompletionClosure?(chatId, image, timestamp, index, completion)
    }

    //MARK: - uploadAudio

    var uploadAudioChatIdDataCompletionCallsCount = 0
    var uploadAudioChatIdDataCompletionCalled: Bool {
        return uploadAudioChatIdDataCompletionCallsCount > 0
    }
    var uploadAudioChatIdDataCompletionReceivedArguments: (chatId: String, data: Data, completion: (_ path: String?, Error?) -> Void)?
    var uploadAudioChatIdDataCompletionReceivedInvocations: [(chatId: String, data: Data, completion: (_ path: String?, Error?) -> Void)] = []
    var uploadAudioChatIdDataCompletionClosure: ((String, Data, @escaping (_ path: String?, Error?) -> Void) -> Void)?

    func uploadAudio(        chatId: String,        data: Data,        completion: @escaping (_ path: String?, Error?) -> Void    ) {
        uploadAudioChatIdDataCompletionCallsCount += 1
        uploadAudioChatIdDataCompletionReceivedArguments = (chatId: chatId, data: data, completion: completion)
        uploadAudioChatIdDataCompletionReceivedInvocations.append((chatId: chatId, data: data, completion: completion))
        uploadAudioChatIdDataCompletionClosure?(chatId, data, completion)
    }

}
