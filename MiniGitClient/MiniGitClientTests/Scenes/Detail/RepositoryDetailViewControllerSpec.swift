/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import Quick
import Nimble
import RxSwift
@testable import MiniGitClient

private class MockPresenter : RepositoryDetailPresenterType {
    
    var repository = Variable(Repository())
    
    var pullRequests = Variable([PullRequest()])
    
    var currentState = Variable(RepositoryDetailState.loading)
    
    var didReturnShareItems = false
    
    var shareItems: [Any] {
        didReturnShareItems = true
        return []
    }
    
}



class RepositoryDetailViewControllerSpec: QuickSpec {
    
    override func spec() {
        
        describe("The RepositoryDetailViewController") { 
            
            var viewController = RepositoryDetailViewController(nibName: nil, bundle: nil)
            
            var mockPresenter = MockPresenter()
            
            var tableView : UITableView?
            
            var headerView : RepositoryDetailHeaderView?
            
            beforeEach {
                viewController = RepositoryDetailViewController(nibName: nil, bundle: nil)
                mockPresenter = MockPresenter()
                viewController.presenter = mockPresenter
                viewController.view.layoutIfNeeded()
                tableView = viewController.view.subviews.flatMap { $0 as? UITableView }.first
                headerView = tableView?.tableHeaderView as? RepositoryDetailHeaderView
            }
            
            context("has", { 
                
                it("a table view") {
                    expect(tableView).toNot(beNil())
                }
                
                it("a header view") {
                    expect(headerView).toNot(beNil())
                }
                
            })
            
            context("changes", {
                
                it("the header view state to loaded when the presenter retrieved the pull requests") {
                    mockPresenter.currentState.value = .showingPullRequests
                    expect(headerView?.currentState.value) == .loaded
                }
                
                it("the header view state to showingRetryOption when the presenter failed") {
                    mockPresenter.currentState.value = .onError
                    expect(headerView?.currentState.value) == .showingRetryOption
                }
                
            })
            
            
            context("shares", { 
                
                it("the presenter's share items through a navigation bar right button item") {
                    guard let shareButton = viewController.navigationItem.rightBarButtonItem else { fail(); return }
                    viewController.share(sender: shareButton)
                    expect(mockPresenter.didReturnShareItems).to(beTrue())
                }
                
            })
            
        }
        
    }
    
}
