/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import Quick
import Nimble
@testable import MiniGitClient

class RepositoryDetailHeaderViewSpec: QuickSpec {
    
    override func spec() {
        
        describe("The RepositoryDetailHeaderView") { 
            
            var headerView = RepositoryDetailHeaderView()
            
            var loadView : LoadMoreView?
            
            beforeEach {
                headerView = RepositoryDetailHeaderView()
                if let stackView = headerView.subviews.first as? UIStackView {
                    loadView = stackView.arrangedSubviews.flatMap{ $0 as? LoadMoreView }.first
                }
            }
            
            context("has", { 
                
                it("a wrapper stack view") {
                    expect(headerView.subviews.count) == 1
                    expect(headerView.subviews.first).to(beAKindOf(UIStackView.self))
                }
                
                it("has a name label") {
                    expect(headerView.nameLabel).toNot(beNil())
                }
                
                it("has an info label") {
                    expect(headerView.infoLabel).toNot(beNil())
                }
                
                it("has a load view") {
                    expect(loadView).toNot(beNil())
                }
                
            })
            
            context("layout", { 
                
                it("intrisic content size is calculated based on its labels and its state") {
                    let height = headerView.nameLabel.intrinsicContentSize.height + headerView.infoLabel.intrinsicContentSize.height + 114
                    expect(headerView.intrinsicContentSize.width) == headerView.bounds.size.width
                    expect(headerView.intrinsicContentSize.height) == height
                    headerView.currentState.value = .loaded
                    expect(headerView.intrinsicContentSize.width) == headerView.bounds.size.width
                    expect(headerView.intrinsicContentSize.height) == height - 48
                }
                
                it("updates the labels preferred max width") {
                    headerView.adjustLayout(withWidth: 100)
                    expect(headerView.nameLabel.preferredMaxLayoutWidth) == 100 - 32
                    expect(headerView.infoLabel.preferredMaxLayoutWidth) == headerView.nameLabel.preferredMaxLayoutWidth
                }
                
            })
            
            context("changes the view hierarchy") {
                
                it("in the loading state") {
                    headerView.currentState.value = .loading
                    expect(loadView?.currentState.value) == .loading
                    expect(loadView?.superview).toNot(beNil())
                }
                
                it("in the showing retry option state") {
                    headerView.currentState.value = .showingRetryOption
                    expect(loadView?.currentState.value) == .normal
                    expect(loadView?.superview).toNot(beNil())
                }
                
                it("in the loaded state") {
                    headerView.currentState.value = .loaded
                    expect(loadView?.superview).to(beNil())
                }
                
            }
        }
        
        
    }
    
}
