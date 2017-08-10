/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import Quick
import Nimble
@testable import MiniGitClient

private class MockRouter : InfoRouterType {
    
    var didDismiss = false

    var didOpenGitHubPage = false
    
    var didOpenMailCompose = false
    
    func dismissController(_ controller: UIViewController) {
        didDismiss = true
    }
    
    func openGitHubPage() {
        didOpenGitHubPage = true
    }
    
    func openMailCompose() {
        didOpenMailCompose = true
    }
    
}

class InfoPresenterSpec: QuickSpec {
    
    override func spec() {
        
        describe("The InfoPresenter") { 
            
            var presenter = InfoPresenter()
            
            var router = MockRouter()
                        
            beforeEach {
                presenter = InfoPresenter()
                router = MockRouter()
                presenter.router = router
            }

            context("router") {
                
                it("opens the GitHub page when the first row of the second section is selected") {
                    presenter.onSelection(ofIndex: 0, atSection: 1, withModel: nil)
                    expect(router.didOpenGitHubPage).to(beTrue())
                }
                
                it("opens the mail compose UI when the second row of the second section is selected") {
                    presenter.onSelection(ofIndex: 1, atSection: 1, withModel: nil)
                    expect(router.didOpenMailCompose).to(beTrue())
                }
            
            }
            
        }
        
    }
    
}
