//
//  ChatViewUITests.swift
//  epam_messengerUITests
//
//  Created by Nickolay Truhin on 18.03.2020.
//

import XCTest

class ChatViewUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func testSendButton() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
                
        let app = XCUIApplication()
        
        app.buttons["Authorize me"].tap()

        app.tables.staticTexts["Testchat1"].tap()
        
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Testchat1"]/*[[".cells.staticTexts[\"Testchat1\"]",".staticTexts[\"Testchat1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.textViews.staticTexts["Message..."].tap()
        
        let sendButton = app.buttons["ic up"]
        XCTAssertFalse(sendButton.isEnabled)
        
        app.textViews.containing(.staticText, identifier: "Message...").element.typeText("testtext")
        
        XCTAssertTrue(sendButton.isEnabled)
    }

    
}
