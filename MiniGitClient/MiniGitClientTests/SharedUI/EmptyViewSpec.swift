/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import Quick
import Nimble
@testable import MiniGitClient

class EmptyViewSpec: QuickSpec {
    
    override func spec() {
        
        var emptyView = EmptyView()
        
        describe("The Empty View") { 
            
            var button : UIButton?
            
            var label : UILabel?
            
            var activityIndicator : UIActivityIndicatorView?
            
            beforeEach {
                emptyView = EmptyView()
                button = emptyView.subviews.flatMap { $0 as? UIButton }.first
                label = emptyView.subviews.flatMap { $0 as? UILabel }.first
                activityIndicator = emptyView.subviews.flatMap { $0 as? UIActivityIndicatorView }.first
            }
            
            context("has", { 
                
                it("3 subviews") {
                    expect(emptyView.subviews.count) == 3
                }
                
                it("an activity indicator") {
                    expect(activityIndicator).toNot(beNil())
                }
                
                it("a message label") {
                    expect(label).toNot(beNil())
                }
                
                it("an action button") {
                    expect(button).toNot(beNil())
                }
                
                it("a message property that changes the label text") {
                    emptyView.message = "message"
                    expect(label?.text) == "message"
                }
                
                it("an action title property") {
                    emptyView.actionTitle = "title"
                    expect(button?.title(for: .normal)) == "title"
                }
                
            })
            
            context("state", {
                
                it("hides the label and button when loading") {
                    emptyView.currentState.value = .loading
                    expect(activityIndicator?.isHidden).to(beFalse())
                    expect(label?.isHidden).to(beTrue())
                    expect(button?.isHidden).to(beTrue())
                }
                
                it("shows the label and button when not loading") {
                    emptyView.currentState.value = .showingError
                    expect(activityIndicator?.isHidden).to(beTrue())
                    expect(label?.isHidden).to(beFalse())
                    expect(button?.isHidden).to(beFalse())
                }
                
            })
            
            context("runs") {
                
                it("an action block when the button is pressed") {
                    var blockDidRun = false
                    emptyView.actionBlock = { blockDidRun = true }
                    button?.sendActions(for: .touchUpInside)
                    expect(blockDidRun).to(beTrue())
                }

            }
            
        }
        
    }
    
}
