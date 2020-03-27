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














class ChatViewModelProtocolMock: ChatViewModelProtocol {

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
    var firestoreQueryReturnValue: Query!
    var firestoreQueryClosure: (() -> Query)?

    func firestoreQuery() -> Query {
        firestoreQueryCallsCount += 1
        return firestoreQueryClosure.map({ $0() }) ?? firestoreQueryReturnValue
    }

    //MARK: - sendMessage

    var sendMessageCompletionCallsCount = 0
    var sendMessageCompletionCalled: Bool {
        return sendMessageCompletionCallsCount > 0
    }
    var sendMessageCompletionReceivedArguments: (messageText: String, completion: (Bool) -> Void)?
    var sendMessageCompletionReceivedInvocations: [(messageText: String, completion: (Bool) -> Void)] = []
    var sendMessageCompletionClosure: ((String, @escaping (Bool) -> Void) -> Void)?

    func sendMessage(        _ messageText: String,        completion: @escaping (Bool) -> Void    ) {
        sendMessageCompletionCallsCount += 1
        sendMessageCompletionReceivedArguments = (messageText: messageText, completion: completion)
        sendMessageCompletionReceivedInvocations.append((messageText: messageText, completion: completion))
        sendMessageCompletionClosure?(messageText, completion)
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

    var sendMessageChatDocumentIdMessageTextCompletionCallsCount = 0
    var sendMessageChatDocumentIdMessageTextCompletionCalled: Bool {
        return sendMessageChatDocumentIdMessageTextCompletionCallsCount > 0
    }
    var sendMessageChatDocumentIdMessageTextCompletionReceivedArguments: (chatDocumentId: String, messageText: String, completion: (Bool) -> Void)?
    var sendMessageChatDocumentIdMessageTextCompletionReceivedInvocations: [(chatDocumentId: String, messageText: String, completion: (Bool) -> Void)] = []
    var sendMessageChatDocumentIdMessageTextCompletionClosure: ((String, String, @escaping (Bool) -> Void) -> Void)?

    func sendMessage(        chatDocumentId: String,        messageText: String,        completion: @escaping (Bool) -> Void    ) {
        sendMessageChatDocumentIdMessageTextCompletionCallsCount += 1
        sendMessageChatDocumentIdMessageTextCompletionReceivedArguments = (chatDocumentId: chatDocumentId, messageText: messageText, completion: completion)
        sendMessageChatDocumentIdMessageTextCompletionReceivedInvocations.append((chatDocumentId: chatDocumentId, messageText: messageText, completion: completion))
        sendMessageChatDocumentIdMessageTextCompletionClosure?(chatDocumentId, messageText, completion)
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
