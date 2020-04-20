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
    var goToChatReceivedChatModel: ChatProtocol?
    var goToChatReceivedInvocations: [ChatProtocol] = []
    var goToChatClosure: ((ChatProtocol) -> Void)?

    func goToChat(        _ chatModel: ChatProtocol    ) {
        goToChatCallsCount += 1
        goToChatReceivedChatModel = chatModel
        goToChatReceivedInvocations.append(chatModel)
        goToChatClosure?(chatModel)
    }

    //MARK: - userListData

    var userListDataCompletionCallsCount = 0
    var userListDataCompletionCalled: Bool {
        return userListDataCompletionCallsCount > 0
    }
    var userListDataCompletionReceivedArguments: (userList: [String], completion: ([UserModel]?) -> Void)?
    var userListDataCompletionReceivedInvocations: [(userList: [String], completion: ([UserModel]?) -> Void)] = []
    var userListDataCompletionClosure: (([String], @escaping ([UserModel]?) -> Void) -> Void)?

    func userListData(        _ userList: [String],        completion: @escaping ([UserModel]?) -> Void    ) {
        userListDataCompletionCallsCount += 1
        userListDataCompletionReceivedArguments = (userList: userList, completion: completion)
        userListDataCompletionReceivedInvocations.append((userList: userList, completion: completion))
        userListDataCompletionClosure?(userList, completion)
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

    //MARK: - sendMessage

    var sendMessageChatIdMessageKindCompletionCallsCount = 0
    var sendMessageChatIdMessageKindCompletionCalled: Bool {
        return sendMessageChatIdMessageKindCompletionCallsCount > 0
    }
    var sendMessageChatIdMessageKindCompletionReceivedArguments: (chatId: String, messageKind: [MessageModel.MessageKind], completion: (Bool) -> Void)?
    var sendMessageChatIdMessageKindCompletionReceivedInvocations: [(chatId: String, messageKind: [MessageModel.MessageKind], completion: (Bool) -> Void)] = []
    var sendMessageChatIdMessageKindCompletionClosure: ((String, [MessageModel.MessageKind], @escaping (Bool) -> Void) -> Void)?

    func sendMessage(        chatId: String,        messageKind: [MessageModel.MessageKind],        completion: @escaping (Bool) -> Void    ) {
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
    var deleteMessageChatIdMessageDocumentIdCompletionReceivedArguments: (chatId: String, messageDocumentId: String, completion: (Bool) -> Void)?
    var deleteMessageChatIdMessageDocumentIdCompletionReceivedInvocations: [(chatId: String, messageDocumentId: String, completion: (Bool) -> Void)] = []
    var deleteMessageChatIdMessageDocumentIdCompletionClosure: ((String, String, @escaping (Bool) -> Void) -> Void)?

    func deleteMessage(        chatId: String,        messageDocumentId: String,        completion: @escaping (Bool) -> Void    ) {
        deleteMessageChatIdMessageDocumentIdCompletionCallsCount += 1
        deleteMessageChatIdMessageDocumentIdCompletionReceivedArguments = (chatId: chatId, messageDocumentId: messageDocumentId, completion: completion)
        deleteMessageChatIdMessageDocumentIdCompletionReceivedInvocations.append((chatId: chatId, messageDocumentId: messageDocumentId, completion: completion))
        deleteMessageChatIdMessageDocumentIdCompletionClosure?(chatId, messageDocumentId, completion)
    }

    //MARK: - leaveChat

    var leaveChatChatIdCompletionCallsCount = 0
    var leaveChatChatIdCompletionCalled: Bool {
        return leaveChatChatIdCompletionCallsCount > 0
    }
    var leaveChatChatIdCompletionReceivedArguments: (chatId: String, completion: (Error?) -> Void)?
    var leaveChatChatIdCompletionReceivedInvocations: [(chatId: String, completion: (Error?) -> Void)] = []
    var leaveChatChatIdCompletionClosure: ((String, @escaping (Error?) -> Void) -> Void)?

    func leaveChat(        chatId: String,        completion: @escaping (Error?) -> Void    ) {
        leaveChatChatIdCompletionCallsCount += 1
        leaveChatChatIdCompletionReceivedArguments = (chatId: chatId, completion: completion)
        leaveChatChatIdCompletionReceivedInvocations.append((chatId: chatId, completion: completion))
        leaveChatChatIdCompletionClosure?(chatId, completion)
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

    //MARK: - clearSavedMessages

    var clearSavedMessagesChatIdCompletionCallsCount = 0
    var clearSavedMessagesChatIdCompletionCalled: Bool {
        return clearSavedMessagesChatIdCompletionCallsCount > 0
    }
    var clearSavedMessagesChatIdCompletionReceivedArguments: (chatId: String, completion: (Error?) -> Void)?
    var clearSavedMessagesChatIdCompletionReceivedInvocations: [(chatId: String, completion: (Error?) -> Void)] = []
    var clearSavedMessagesChatIdCompletionClosure: ((String, @escaping (Error?) -> Void) -> Void)?

    func clearSavedMessages(        chatId: String,        completion: @escaping (Error?) -> Void    ) {
        clearSavedMessagesChatIdCompletionCallsCount += 1
        clearSavedMessagesChatIdCompletionReceivedArguments = (chatId: chatId, completion: completion)
        clearSavedMessagesChatIdCompletionReceivedInvocations.append((chatId: chatId, completion: completion))
        clearSavedMessagesChatIdCompletionClosure?(chatId, completion)
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

    //MARK: - createUser

    var createUserCompletionCallsCount = 0
    var createUserCompletionCalled: Bool {
        return createUserCompletionCallsCount > 0
    }
    var createUserCompletionReceivedArguments: (userModel: UserModel, completion: (Error?) -> Void)?
    var createUserCompletionReceivedInvocations: [(userModel: UserModel, completion: (Error?) -> Void)] = []
    var createUserCompletionReturnValue: String!
    var createUserCompletionClosure: ((UserModel, @escaping (Error?) -> Void) -> String)?

    func createUser(        _ userModel: UserModel,        completion: @escaping (Error?) -> Void    ) -> String {
        createUserCompletionCallsCount += 1
        createUserCompletionReceivedArguments = (userModel: userModel, completion: completion)
        createUserCompletionReceivedInvocations.append((userModel: userModel, completion: completion))
        return createUserCompletionClosure.map({ $0(userModel, completion) }) ?? createUserCompletionReturnValue
    }

    //MARK: - createChat

    var createChatCompletionCallsCount = 0
    var createChatCompletionCalled: Bool {
        return createChatCompletionCallsCount > 0
    }
    var createChatCompletionReceivedArguments: (chatModel: ChatModel, completion: (Error?) -> Void)?
    var createChatCompletionReceivedInvocations: [(chatModel: ChatModel, completion: (Error?) -> Void)] = []
    var createChatCompletionReturnValue: String!
    var createChatCompletionClosure: ((ChatModel, @escaping (Error?) -> Void) -> String)?

    func createChat(        _ chatModel: ChatModel,        completion: @escaping (Error?) -> Void    ) -> String {
        createChatCompletionCallsCount += 1
        createChatCompletionReceivedArguments = (chatModel: chatModel, completion: completion)
        createChatCompletionReceivedInvocations.append((chatModel: chatModel, completion: completion))
        return createChatCompletionClosure.map({ $0(chatModel, completion) }) ?? createChatCompletionReturnValue
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

    //MARK: - userListData

    var userListDataCompletionCallsCount = 0
    var userListDataCompletionCalled: Bool {
        return userListDataCompletionCallsCount > 0
    }
    var userListDataCompletionReceivedArguments: (userList: [String], completion: ([UserModel]?) -> Void)?
    var userListDataCompletionReceivedInvocations: [(userList: [String], completion: ([UserModel]?) -> Void)] = []
    var userListDataCompletionClosure: (([String], @escaping ([UserModel]?) -> Void) -> Void)?

    func userListData(        _ userList: [String],        completion: @escaping ([UserModel]?) -> Void    ) {
        userListDataCompletionCallsCount += 1
        userListDataCompletionReceivedArguments = (userList: userList, completion: completion)
        userListDataCompletionReceivedInvocations.append((userList: userList, completion: completion))
        userListDataCompletionClosure?(userList, completion)
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

}
class ImagePickerServiceProtocolMock: ImagePickerServiceProtocol {

    //MARK: - pickImages

    var pickImagesCompletionCallsCount = 0
    var pickImagesCompletionCalled: Bool {
        return pickImagesCompletionCallsCount > 0
    }
    var pickImagesCompletionReceivedCompletion: (ImageCompletion)?
    var pickImagesCompletionReceivedInvocations: [(ImageCompletion)] = []
    var pickImagesCompletionClosure: ((@escaping ImageCompletion) -> Void)?

    func pickImages(completion: @escaping ImageCompletion) {
        pickImagesCompletionCallsCount += 1
        pickImagesCompletionReceivedCompletion = completion
        pickImagesCompletionReceivedInvocations.append(completion)
        pickImagesCompletionClosure?(completion)
    }

    //MARK: - pickSingleImage

    var pickSingleImageCompletionCallsCount = 0
    var pickSingleImageCompletionCalled: Bool {
        return pickSingleImageCompletionCallsCount > 0
    }
    var pickSingleImageCompletionReceivedCompletion: (ImageCompletion)?
    var pickSingleImageCompletionReceivedInvocations: [(ImageCompletion)] = []
    var pickSingleImageCompletionClosure: ((@escaping ImageCompletion) -> Void)?

    func pickSingleImage(completion: @escaping ImageCompletion) {
        pickSingleImageCompletionCallsCount += 1
        pickSingleImageCompletionReceivedCompletion = completion
        pickSingleImageCompletionReceivedInvocations.append(completion)
        pickSingleImageCompletionClosure?(completion)
    }

    //MARK: - pickCamera

    var pickCameraCompletionCallsCount = 0
    var pickCameraCompletionCalled: Bool {
        return pickCameraCompletionCallsCount > 0
    }
    var pickCameraCompletionReceivedCompletion: (ImageCompletion)?
    var pickCameraCompletionReceivedInvocations: [(ImageCompletion)] = []
    var pickCameraCompletionClosure: ((@escaping ImageCompletion) -> Void)?

    func pickCamera(completion: @escaping ImageCompletion) {
        pickCameraCompletionCallsCount += 1
        pickCameraCompletionReceivedCompletion = completion
        pickCameraCompletionReceivedInvocations.append(completion)
        pickCameraCompletionClosure?(completion)
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

    //MARK: - showChatPicker

    var showChatPickerSelectDelegateCallsCount = 0
    var showChatPickerSelectDelegateCalled: Bool {
        return showChatPickerSelectDelegateCallsCount > 0
    }
    var showChatPickerSelectDelegateReceivedSelectDelegate: ChatSelectDelegate?
    var showChatPickerSelectDelegateReceivedInvocations: [ChatSelectDelegate] = []
    var showChatPickerSelectDelegateClosure: ((ChatSelectDelegate) -> Void)?

    func showChatPicker(selectDelegate: ChatSelectDelegate) {
        showChatPickerSelectDelegateCallsCount += 1
        showChatPickerSelectDelegateReceivedSelectDelegate = selectDelegate
        showChatPickerSelectDelegateReceivedInvocations.append(selectDelegate)
        showChatPickerSelectDelegateClosure?(selectDelegate)
    }

}
class StorageServiceProtocolMock: StorageServiceProtocol {

    //MARK: - uploadUserAvatar

    var uploadUserAvatarUserIdAvatarCompletionCallsCount = 0
    var uploadUserAvatarUserIdAvatarCompletionCalled: Bool {
        return uploadUserAvatarUserIdAvatarCompletionCallsCount > 0
    }
    var uploadUserAvatarUserIdAvatarCompletionReceivedArguments: (userId: String, avatar: UIImage, completion: (Error?) -> Void)?
    var uploadUserAvatarUserIdAvatarCompletionReceivedInvocations: [(userId: String, avatar: UIImage, completion: (Error?) -> Void)] = []
    var uploadUserAvatarUserIdAvatarCompletionClosure: ((String, UIImage, @escaping (Error?) -> Void) -> Void)?

    func uploadUserAvatar(        userId: String,        avatar: UIImage,        completion: @escaping (Error?) -> Void    ) {
        uploadUserAvatarUserIdAvatarCompletionCallsCount += 1
        uploadUserAvatarUserIdAvatarCompletionReceivedArguments = (userId: userId, avatar: avatar, completion: completion)
        uploadUserAvatarUserIdAvatarCompletionReceivedInvocations.append((userId: userId, avatar: avatar, completion: completion))
        uploadUserAvatarUserIdAvatarCompletionClosure?(userId, avatar, completion)
    }

    //MARK: - uploadImage

    var uploadImageChatIdImageTimestampIndexCompletionCallsCount = 0
    var uploadImageChatIdImageTimestampIndexCompletionCalled: Bool {
        return uploadImageChatIdImageTimestampIndexCompletionCallsCount > 0
    }
    var uploadImageChatIdImageTimestampIndexCompletionReceivedArguments: (chatId: String, image: UIImage, timestamp: Date, index: Int, completion: (MessageModel.MessageKind?, Error?) -> Void)?
    var uploadImageChatIdImageTimestampIndexCompletionReceivedInvocations: [(chatId: String, image: UIImage, timestamp: Date, index: Int, completion: (MessageModel.MessageKind?, Error?) -> Void)] = []
    var uploadImageChatIdImageTimestampIndexCompletionClosure: ((String, UIImage, Date, Int, @escaping (MessageModel.MessageKind?, Error?) -> Void) -> Void)?

    func uploadImage(        chatId: String,        image: UIImage,        timestamp: Date,        index: Int,        completion: @escaping (MessageModel.MessageKind?, Error?) -> Void    ) {
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
    var uploadAudioChatIdDataCompletionReceivedArguments: (chatId: String, data: Data, completion: (MessageModel.MessageKind?, Error?) -> Void)?
    var uploadAudioChatIdDataCompletionReceivedInvocations: [(chatId: String, data: Data, completion: (MessageModel.MessageKind?, Error?) -> Void)] = []
    var uploadAudioChatIdDataCompletionClosure: ((String, Data, @escaping (MessageModel.MessageKind?, Error?) -> Void) -> Void)?

    func uploadAudio(        chatId: String,        data: Data,        completion: @escaping (MessageModel.MessageKind?, Error?) -> Void    ) {
        uploadAudioChatIdDataCompletionCallsCount += 1
        uploadAudioChatIdDataCompletionReceivedArguments = (chatId: chatId, data: data, completion: completion)
        uploadAudioChatIdDataCompletionReceivedInvocations.append((chatId: chatId, data: data, completion: completion))
        uploadAudioChatIdDataCompletionClosure?(chatId, data, completion)
    }

}
