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

}
class ChatViewModelProtocolMock: ChatViewModelProtocol {
    var chat: ChatProtocol {
        get { return underlyingChat }
        set(value) { underlyingChat = value }
    }
    var underlyingChat: ChatProtocol!
    var baseQuery: FireQuery {
        get { return underlyingBaseQuery }
        set(value) { underlyingBaseQuery = value }
    }
    var underlyingBaseQuery: FireQuery!
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
    var deleteChatCompletionReceivedCompletion: ((Bool) -> Void)?
    var deleteChatCompletionReceivedInvocations: [((Bool) -> Void)] = []
    var deleteChatCompletionClosure: ((@escaping (Bool) -> Void) -> Void)?

    func deleteChat(        completion: @escaping (Bool) -> Void    ) {
        deleteChatCompletionCallsCount += 1
        deleteChatCompletionReceivedCompletion = completion
        deleteChatCompletionReceivedInvocations.append(completion)
        deleteChatCompletionClosure?(completion)
    }

    //MARK: - createForwardViewController

    var createForwardViewControllerForwardDelegateCallsCount = 0
    var createForwardViewControllerForwardDelegateCalled: Bool {
        return createForwardViewControllerForwardDelegateCallsCount > 0
    }
    var createForwardViewControllerForwardDelegateReceivedForwardDelegate: ForwardDelegate?
    var createForwardViewControllerForwardDelegateReceivedInvocations: [ForwardDelegate] = []
    var createForwardViewControllerForwardDelegateReturnValue: UIViewController!
    var createForwardViewControllerForwardDelegateClosure: ((ForwardDelegate) -> UIViewController)?

    func createForwardViewController(        forwardDelegate: ForwardDelegate    ) -> UIViewController {
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
    var goToChatReceivedChatModel: ChatProtocol?
    var goToChatReceivedInvocations: [ChatProtocol] = []
    var goToChatClosure: ((ChatProtocol) -> Void)?

    func goToChat(        _ chatModel: ChatProtocol    ) {
        goToChatCallsCount += 1
        goToChatReceivedChatModel = chatModel
        goToChatReceivedInvocations.append(chatModel)
        goToChatClosure?(chatModel)
    }

    //MARK: - userData

    var userDataCompletionCallsCount = 0
    var userDataCompletionCalled: Bool {
        return userDataCompletionCallsCount > 0
    }
    var userDataCompletionReceivedArguments: (userId: String, completion: (UserModel?) -> Void)?
    var userDataCompletionReceivedInvocations: [(userId: String, completion: (UserModel?) -> Void)] = []
    var userDataCompletionClosure: ((String, @escaping (UserModel?) -> Void) -> Void)?

    func userData(        _ userId: String,        completion: @escaping (UserModel?) -> Void    ) {
        userDataCompletionCallsCount += 1
        userDataCompletionReceivedArguments = (userId: userId, completion: completion)
        userDataCompletionReceivedInvocations.append((userId: userId, completion: completion))
        userDataCompletionClosure?(userId, completion)
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

    //MARK: - deleteChat

    var deleteChatChatIdCompletionCallsCount = 0
    var deleteChatChatIdCompletionCalled: Bool {
        return deleteChatChatIdCompletionCallsCount > 0
    }
    var deleteChatChatIdCompletionReceivedArguments: (chatId: String, completion: (Bool) -> Void)?
    var deleteChatChatIdCompletionReceivedInvocations: [(chatId: String, completion: (Bool) -> Void)] = []
    var deleteChatChatIdCompletionClosure: ((String, @escaping (Bool) -> Void) -> Void)?

    func deleteChat(        chatId: String,        completion: @escaping (Bool) -> Void    ) {
        deleteChatChatIdCompletionCallsCount += 1
        deleteChatChatIdCompletionReceivedArguments = (chatId: chatId, completion: completion)
        deleteChatChatIdCompletionReceivedInvocations.append((chatId: chatId, completion: completion))
        deleteChatChatIdCompletionClosure?(chatId, completion)
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
    var createUserCompletionReceivedArguments: (userModel: UserModel, completion: (Bool) -> Void)?
    var createUserCompletionReceivedInvocations: [(userModel: UserModel, completion: (Bool) -> Void)] = []
    var createUserCompletionReturnValue: String!
    var createUserCompletionClosure: ((UserModel, @escaping (Bool) -> Void) -> String)?

    func createUser(        _ userModel: UserModel,        completion: @escaping (Bool) -> Void    ) -> String {
        createUserCompletionCallsCount += 1
        createUserCompletionReceivedArguments = (userModel: userModel, completion: completion)
        createUserCompletionReceivedInvocations.append((userModel: userModel, completion: completion))
        return createUserCompletionClosure.map({ $0(userModel, completion) }) ?? createUserCompletionReturnValue
    }

    //MARK: - currentUserData

    var currentUserDataCompletionCallsCount = 0
    var currentUserDataCompletionCalled: Bool {
        return currentUserDataCompletionCallsCount > 0
    }
    var currentUserDataCompletionReceivedCompletion: ((UserModel?) -> Void)?
    var currentUserDataCompletionReceivedInvocations: [((UserModel?) -> Void)] = []
    var currentUserDataCompletionClosure: ((@escaping (UserModel?) -> Void) -> Void)?

    func currentUserData(        completion: @escaping (UserModel?) -> Void    ) {
        currentUserDataCompletionCallsCount += 1
        currentUserDataCompletionReceivedCompletion = completion
        currentUserDataCompletionReceivedInvocations.append(completion)
        currentUserDataCompletionClosure?(completion)
    }

    //MARK: - userData

    var userDataCompletionCallsCount = 0
    var userDataCompletionCalled: Bool {
        return userDataCompletionCallsCount > 0
    }
    var userDataCompletionReceivedArguments: (userId: String, completion: (UserModel?) -> Void)?
    var userDataCompletionReceivedInvocations: [(userId: String, completion: (UserModel?) -> Void)] = []
    var userDataCompletionClosure: ((String, @escaping (UserModel?) -> Void) -> Void)?

    func userData(        _ userId: String,        completion: @escaping (UserModel?) -> Void    ) {
        userDataCompletionCallsCount += 1
        userDataCompletionReceivedArguments = (userId: userId, completion: completion)
        userDataCompletionReceivedInvocations.append((userId: userId, completion: completion))
        userDataCompletionClosure?(userId, completion)
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

    //MARK: - chatData

    var chatDataCompletionCallsCount = 0
    var chatDataCompletionCalled: Bool {
        return chatDataCompletionCallsCount > 0
    }
    var chatDataCompletionReceivedArguments: (chatId: String, completion: (ChatModel?) -> Void)?
    var chatDataCompletionReceivedInvocations: [(chatId: String, completion: (ChatModel?) -> Void)] = []
    var chatDataCompletionClosure: ((String, @escaping (ChatModel?) -> Void) -> Void)?

    func chatData(        _ chatId: String,        completion: @escaping (ChatModel?) -> Void    ) {
        chatDataCompletionCallsCount += 1
        chatDataCompletionReceivedArguments = (chatId: chatId, completion: completion)
        chatDataCompletionReceivedInvocations.append((chatId: chatId, completion: completion))
        chatDataCompletionClosure?(chatId, completion)
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

}
class StorageServiceProtocolMock: StorageServiceProtocol {

    //MARK: - uploadUserAvatar

    var uploadUserAvatarUserIdAvatarCompletionCallsCount = 0
    var uploadUserAvatarUserIdAvatarCompletionCalled: Bool {
        return uploadUserAvatarUserIdAvatarCompletionCallsCount > 0
    }
    var uploadUserAvatarUserIdAvatarCompletionReceivedArguments: (userId: String, avatar: UIImage, completion: (Bool) -> Void)?
    var uploadUserAvatarUserIdAvatarCompletionReceivedInvocations: [(userId: String, avatar: UIImage, completion: (Bool) -> Void)] = []
    var uploadUserAvatarUserIdAvatarCompletionClosure: ((String, UIImage, @escaping (Bool) -> Void) -> Void)?

    func uploadUserAvatar(        userId: String,        avatar: UIImage,        completion: @escaping (Bool) -> Void    ) {
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
    var uploadImageChatIdImageTimestampIndexCompletionReceivedArguments: (chatId: String, image: UIImage, timestamp: Date, index: Int, completion: (MessageModel.MessageKind?) -> Void)?
    var uploadImageChatIdImageTimestampIndexCompletionReceivedInvocations: [(chatId: String, image: UIImage, timestamp: Date, index: Int, completion: (MessageModel.MessageKind?) -> Void)] = []
    var uploadImageChatIdImageTimestampIndexCompletionClosure: ((String, UIImage, Date, Int, @escaping (MessageModel.MessageKind?) -> Void) -> Void)?

    func uploadImage(        chatId: String,        image: UIImage,        timestamp: Date,        index: Int,        completion: @escaping (MessageModel.MessageKind?) -> Void    ) {
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
    var uploadAudioChatIdDataCompletionReceivedArguments: (chatId: String, data: Data, completion: (MessageModel.MessageKind?) -> Void)?
    var uploadAudioChatIdDataCompletionReceivedInvocations: [(chatId: String, data: Data, completion: (MessageModel.MessageKind?) -> Void)] = []
    var uploadAudioChatIdDataCompletionClosure: ((String, Data, @escaping (MessageModel.MessageKind?) -> Void) -> Void)?

    func uploadAudio(        chatId: String,        data: Data,        completion: @escaping (MessageModel.MessageKind?) -> Void    ) {
        uploadAudioChatIdDataCompletionCallsCount += 1
        uploadAudioChatIdDataCompletionReceivedArguments = (chatId: chatId, data: data, completion: completion)
        uploadAudioChatIdDataCompletionReceivedInvocations.append((chatId: chatId, data: data, completion: completion))
        uploadAudioChatIdDataCompletionClosure?(chatId, data, completion)
    }

}
