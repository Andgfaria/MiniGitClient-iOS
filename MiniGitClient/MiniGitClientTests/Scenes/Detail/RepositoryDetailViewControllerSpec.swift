//
//  RepositoryDetailViewControllerSpec.swift
//  MiniGitClient
//
//  Created by Andre Faria on 24/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

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
