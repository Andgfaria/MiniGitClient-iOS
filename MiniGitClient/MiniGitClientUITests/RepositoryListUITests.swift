/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import XCTest

class RepositoryListUITests: XCTestCase {
        
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
       
        UITestHelper.scroll(onElement: listTableView, withScrollDirection: .up, times: 15) { loadMoreButton.isHittable }
        loadMoreButton.tap()
        
        let activityIndicator = app.activityIndicators["LoadMoreViewActivityIndicator"]
        let secondFetchExpecation = expectation(for: NSPredicate(format: "isHittable == 0"), evaluatedWith: activityIndicator, handler: nil)
        wait(for: [secondFetchExpecation], timeout: 20.0)
        
        listTableView.cells.element(boundBy: 30).tap()
    }
    
}
