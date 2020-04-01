//
//  ChatViewModelTests.swift
//  epam_messengerTests
//
//  Created by Nickolay Truhin on 18.03.2020.
//

import XCTest
import Firebase
@testable import epam_messenger

class ChatViewModelTests: XCTestCase {
    
    var viewModel: ChatViewModel!
    var viewController = ChatViewControllerProtocolMock()
    var firestoreService = FirestoreServiceProtocolMock()
    var storageService = StorageServiceProtocolMock()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = ChatViewModel(
            viewController: viewController,
            router: RouterProtocolMock(),
            chatModel: ChatModel(
                users: [23, 45, 12],
                name: "test name",
                lastMessage: nil
            ),
            firestoreService: firestoreService,
            storageService: storageService
        )
        storageService.uploadImageChatDocumentIdImageNameSuffixCompletionClosure = { _, _, _, completion in
            completion(.image(path: "testpath", size: .init(width: 300, height: 300)))
        }
    }
    
    func testDeleteMessage() {
        viewModel.deleteMessage(
                MessageModel.init(
                    documentId: "testdocid",
                    kind: [ .text("testtext") ],
                    userId: 0,
                    timestamp: Timestamp()
            )
        )
        
        XCTAssertTrue(firestoreService.deleteMessageChatDocumentIdMessageDocumentIdCompletionCalled)
    }
    
    func testSendMessage() {
        viewModel.sendMessage("test message", attachments: [
            .image(UIImage())
        ])
        
        XCTAssertTrue(storageService.uploadImageChatDocumentIdImageNameSuffixCompletionCalled)
        
        let expectation = XCTestExpectation(description: "Async storage images load")
        
        firestoreService.sendMessageChatDocumentIdMessageKindCompletionClosure = { _, _, _ in
            expectation.fulfill()
        }
        
        let result = XCTWaiter.wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(result, .completed)
        XCTAssertTrue(firestoreService.sendMessageChatDocumentIdMessageKindCompletionCalled)
    }
    
}
