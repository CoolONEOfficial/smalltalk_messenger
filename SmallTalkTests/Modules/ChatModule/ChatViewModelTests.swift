//
//  ChatViewModelTests.swift
//  SmallTalkTests
//
//  Created by Nickolay Truhin on 06.05.2020.
//

import XCTest
import Firebase
@testable import SmallTalk

class ChatViewModelTests: XCTestCase {
    
    var viewModel: ChatViewModel!
    var viewController = ChatViewControllerProtocolMock()
    var firestoreService = FirestoreServiceProtocolMock()
    var storageService = StorageServiceProtocolMock()
    
    override func setUp() {
        viewModel = ChatViewModel(
            router: RouterProtocolMock(),
            viewController: viewController,
            chat: ChatModel(
                documentId: "123123123",
                users: ["12", "23", "34"],
                lastMessage: .init(
                    documentId: nil, kind: [], userId: "12",
                    timestamp: .init(), chatId: nil, chatUsers: nil
                ),
                type: .chat(
                    title: "",
                    adminId: "12",
                    hexColor: nil,
                    avatarPath: nil
                )
            ),
            firestoreService: firestoreService,
            storageService: storageService
        )
        
        storageService.uploadImageChatIdImageTimestampIndexCompletionClosure = { _, _, _, _, completion in
            completion((path: "testpath", size: .init(width: 300, height: 300)), nil)
        }
    }
    
    func testDeleteMessage() {
        viewModel.deleteMessage(MessageModel(
            documentId: "123", kind: [], userId: "12",
            timestamp: .init(), chatId: nil, chatUsers: nil
        ))
        
        XCTAssertTrue(firestoreService.deleteMessageChatIdMessageDocumentIdCompletionCalled)
    }
    
    func testSendMessage() {
        viewModel.sendMessage(attachments: [
            .image(UIImage())
        ])
        
        XCTAssertTrue(storageService.uploadImageChatIdImageTimestampIndexCompletionCalled)
        
        let expectation = XCTestExpectation(description: "Async storage images load")
        
        firestoreService.sendMessageChatIdMessageKindCompletionClosure = { _, _, _ in
            expectation.fulfill()
        }
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(result, .completed)
        XCTAssertTrue(firestoreService.sendMessageChatIdMessageKindCompletionCalled)
    }
    
}
