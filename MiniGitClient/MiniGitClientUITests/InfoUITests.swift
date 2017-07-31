//
//  InfoUITests.swift
//  MiniGitClient
//
//  Created by Andre Faria on 31/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import XCTest

class InfoUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testPortraitInfoScreenRouting() {
        XCUIDevice.shared().orientation = .portrait
        enterAndDismissInfoScreen()
    }
    
    func testLandscapeInfoScreenRouting() {
        XCUIDevice.shared().orientation = .landscapeLeft
        enterAndDismissInfoScreen()
    }
    
    func testPortraitGitHubPageSelection() {
        XCUIDevice.shared().orientation = .portrait
        openInfoLink(atIndex: 1)
    }
    
    func testLandscapeGitHubPageSelection() {
        XCUIDevice.shared().orientation = .landscapeLeft
        openInfoLink(atIndex: 1)
    }

    func testPortraitMailComposeSelection() {
        XCUIDevice.shared().orientation = .portrait
        openInfoLink(atIndex: 2)
    }
    
    func testLandscapeMailComposeSelection() {
        XCUIDevice.shared().orientation = .landscapeLeft
        openInfoLink(atIndex: 2)
    }
    
    private func enterAndDismissInfoScreen() {
        let app = XCUIApplication()
        
        app.buttons["InfoButton"].tap()
        
        let infoTableView = app.tables["InfoTableView"]
        infoTableView.cells.element(boundBy: 0).tap()
        
        let infoDoneButton = app.navigationBars.buttons["InfoDoneButton"]
        
        if infoDoneButton.exists {
            infoDoneButton.tap()
        }
        else {
            app.windows.element(boundBy: 0).tap()
        }
        
        XCTAssert(app.tables["RepositoriesListTableView"].isHittable)
    }
    
    
    private func openInfoLink(atIndex index : UInt) {
        let app = XCUIApplication()
        
        app.buttons["InfoButton"].tap()
        
        let infoTableView = app.tables["InfoTableView"]
        infoTableView.cells.element(boundBy: index).tap()
    }
    
}
