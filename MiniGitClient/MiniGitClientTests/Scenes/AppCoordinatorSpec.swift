/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import Quick
import Nimble
@testable import MiniGitClient

class AppCoordinatorSpec: QuickSpec {
    
    override func spec() {
        
        describe("The App Coordinator") { 
            
            it("begins the app flow with a UISplitViewController") {
                AppCoordinator().start()
                expect(UIApplication.shared.delegate?.window??.rootViewController is UISplitViewController).to(beTrue())
            }
            
            it("presents the master screen as a navigation controller with a RepositoryListViewController") {
                AppCoordinator().start()
                let splitViewController = UIApplication.shared.delegate?.window??.rootViewController as? UISplitViewController
                let navigationController = splitViewController?.viewControllers[0] as? UINavigationController
                let master = navigationController?.viewControllers[0] as? RepositoryListViewController
                expect(master).toNot(beNil())
            }
            
        }
        
    }
    
}
