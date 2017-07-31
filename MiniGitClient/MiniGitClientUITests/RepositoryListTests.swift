//
//  MiniGitClientUITests.swift
//  MiniGitClientUITests
//
//  Created by André Gimenez Faria on 20/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import XCTest

class RepositoryListTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testPortraitRepositoriesBrowsing() {
        XCUIDevice.shared().orientation = .portrait
        browseRepositories()
    }
    
    func testLandscapeRepositoriesBrowsing() {
        XCUIDevice.shared().orientation = .landscapeLeft
        browseRepositories()
    }
    
    private func browseRepositories() {
        let app = XCUIApplication()
        let listTableView = app.tables["RepositoriesListTableView"]
        let firstFetchExpectation = expectation(for: NSPredicate(format: "isHittable == 1"), evaluatedWith: listTableView, handler: nil)
        wait(for: [firstFetchExpectation], timeout: 20.0)
        
        let loadMoreButton = app.buttons["LoadMoreViewButton"]
        
        for _ in 0..<15 {
            if loadMoreButton.isHittable {
                break
            }
            listTableView.swipeUp()
        }
        
        loadMoreButton.tap()
        
        let activityIndicator = app.activityIndicators["LoadMoreViewActivityIndicator"]
        
        let secondFetchExpecation = expectation(for: NSPredicate(format: "isHittable == 0"), evaluatedWith: activityIndicator, handler: nil)
        wait(for: [secondFetchExpecation], timeout: 20.0)
        
        listTableView.cells.element(boundBy: 30).tap()
    }
    
}
