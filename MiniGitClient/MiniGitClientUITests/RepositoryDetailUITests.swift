/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

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
