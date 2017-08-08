/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import Quick
import Nimble
@testable import MiniGitClient

class LoadMoreViewSpec: QuickSpec {
    
    override func spec() {
        
        describe("The LoadMoreView") { 
            
            var loadMoreView = LoadMoreView()
            
            var activityIndicator : UIActivityIndicatorView?
            
            var loadMoreButton : UIButton?
            
            beforeEach {
                loadMoreView = LoadMoreView()
                activityIndicator = loadMoreView.subviews.flatMap { $0 as? UIActivityIndicatorView }.first
                loadMoreButton = loadMoreView.subviews.flatMap { $0 as? UIButton }.first
            }
            
            context("has", {
                
                it("2 subviews") {
                    expect(loadMoreView.subviews.count) == 2
                }
                
                it("an activity indicator") {
                    expect(activityIndicator).toNot(beNil())
                }
                
                it("a load more button") {
                    expect(loadMoreButton).toNot(beNil())
                }
                
                it("a load title property that changes the button title") {
                    loadMoreView.loadTitle = "Test"
                    expect(loadMoreButton?.title(for: .normal)) == "Test"
                }
                
            })
            
            context("state", { 
                
                it("hides the activity indicator when normal") {
                    loadMoreView.currentState.value = .normal
                    expect(activityIndicator?.isHidden).to(beTrue())
                    expect(loadMoreButton?.isHidden).to(beFalse())
                }
                
                it("hides the load button when loading") {
                    loadMoreView.currentState.value = .loading
                    expect(activityIndicator?.isHidden).to(beFalse())
                    expect(loadMoreButton?.isHidden).to(beTrue())
                }
                
            })
            
            context("runs", {
                
                it("a loading block when the button is pressed") {
                    var blockDidRun = false
                    loadMoreView.loadingBlock = { blockDidRun = true }
                    loadMoreButton?.sendActions(for: .touchUpInside)
                    expect(blockDidRun).to(beTrue())
                }
                
            })
            
        }
        
    }
    
}
