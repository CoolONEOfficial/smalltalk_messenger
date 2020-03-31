//
//  ChatViewModelTests.swift
//  epam_messengerTests
//
//  Created by Nickolay Truhin on 18.03.2020.
//

import XCTest
@testable import epam_messenger

class ChatViewModelTests: XCTestCase {
    
    var viewModel: ChatViewModel!
    var firestoreService = FirestoreServiceProtocolMock()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = ChatViewModel(
            router: RouterProtocolMock(),
            chatModel: ChatModel(
                users: [23, 45, 12],
                name: "test name",
                lastMessage: nil
            ),
            firestoreService: firestoreService
        )
    }
    
    func testDeleteMessage() {
        viewModel.deleteMessage(
                MessageModel.init(
                text: "test message",
                userId: 0,
                timestamp: .init()
            )
        )
        
        XCTAssertTrue(firestoreService.deleteMessageChatDocumentIdMessageDocumentIdCompletionCalled)
    }
    
    func testSendMessage() {
        viewModel.deleteMessage(
                MessageModel.init(
                text: "test message",
                userId: 0,
                timestamp: .init()
            )
        )
        
        XCTAssertTrue(firestoreService.deleteMessageChatDocumentIdMessageDocumentIdCompletionCalled)
    }
    
}
