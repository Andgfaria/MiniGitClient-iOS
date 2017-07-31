//
//  RepositoryDetailUITests.swift
//  MiniGitClient
//
//  Created by Andre Faria on 31/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import XCTest

class RepositoryDetailUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testPortraitPullRequestInfo() {
        XCUIDevice.shared().orientation = .portrait
        openPullRequestInfo()
    }
    
    func testLandscapePullRequestInfo() {
        XCUIDevice.shared().orientation = .landscapeLeft
        openPullRequestInfo()
    }
    
    func testPortraitRepositoryShare() {
        XCUIDevice.shared().orientation = .portrait
        shareRepository()
    }
    
    func testLandscapeRepositoryShare() {
        XCUIDevice.shared().orientation = .landscapeLeft
        shareRepository()
    }
    
    private func openPullRequestInfo() {
        let app = XCUIApplication()
        
        goToDetailScreen()
        
        let firstPullRequestCell = app.tables["PullRequestsTableView"].cells.element(boundBy: 0)
        let secondFetchExpectation = expectation(for: NSPredicate(format: "isHittable == 1"), evaluatedWith: firstPullRequestCell, handler: nil)
        wait(for: [secondFetchExpectation], timeout: 20.0)
        
        firstPullRequestCell.tap()
        
        app.buttons["Done"].tap()
    }
    
    private func shareRepository() {
        let app = XCUIApplication()
        
        goToDetailScreen()

        app.buttons["RepositoryDetailShareButton"].tap()
    }
    
    private func goToDetailScreen() {
        let app = XCUIApplication()
        let listTableView = app.tables["RepositoriesListTableView"]
        let firstFetchExpectation = expectation(for: NSPredicate(format: "isHittable == 1"), evaluatedWith: listTableView, handler: nil)
        wait(for: [firstFetchExpectation], timeout: 20.0)
        listTableView.cells.element(boundBy: 0).tap()
    }
    
}
