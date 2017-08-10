/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

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
