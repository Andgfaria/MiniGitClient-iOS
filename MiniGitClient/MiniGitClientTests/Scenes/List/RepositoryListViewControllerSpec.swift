//
//  RepositoryListViewControllerSpec.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 04/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
import RxSwift
@testable import MiniGitClient

fileprivate class MockPresenter : NSObject, RepositoryListPresenterType {
    
    var didHandleInfoButtonTap = false
    
    var currentState: Variable<RepositoryListState> = Variable(RepositoryListState.loadingFirst)
    
    weak var viewController : RepositoryListViewController?
    
    func onInfoButtonTap() {
        didHandleInfoButtonTap = true
    }
}


class RepositoryListViewControllerSpec: QuickSpec {

    override func spec() {
        
        describe("The RepositoryListViewController") {
            
            var controller = RepositoryListViewController(nibName: nil, bundle: nil)
            
            var emptyView : EmptyView?
            
            var tableView : UITableView?
            
            var loadMoreView : LoadMoreView?
            
            var mockPresenter = MockPresenter()
            
            var tableViewModel = RepositoryListTableViewModel()
            
            beforeEach {
                mockPresenter = MockPresenter()
                tableViewModel = RepositoryListTableViewModel()
                controller = RepositoryListViewController(nibName: nil, bundle: nil)
                controller.presenter = mockPresenter
                controller.tableViewModel = tableViewModel
                _ = controller.view
                emptyView = controller.view.subviews.flatMap { $0 as? EmptyView }.first
                tableView = controller.view.subviews.flatMap { $0 as? UITableView }.first
                loadMoreView = tableView?.tableFooterView as? LoadMoreView
            }
            
            context("has", { 
                
                it("2 subviews") {
                    expect(controller.view.subviews.count) == 2
                }
                
                it("an empty view") {
                    expect(emptyView).toNot(beNil())
                }
                
                it("a table view") {
                    expect(tableView).toNot(beNil())
                }
                
                it("a load more view as the table view footer") {
                    expect(loadMoreView).toNot(beNil())
                }
                
            })
            
            context("changes", { 
                
                it("to a loading first state") {
                    mockPresenter.currentState.value = .loadingFirst
                    expect(emptyView?.isHidden).to(beFalse())
                    expect(tableView?.isHidden).to(beTrue())
                }
                
                it("to a loading more state") {
                    mockPresenter.currentState.value = .loadingMore
                    expect(emptyView?.isHidden).to(beTrue())
                    expect(tableView?.isHidden).to(beFalse())
                }
                
                it("to a showing repositories state") {
                    mockPresenter.currentState.value = .showingRepositories
                    expect(emptyView?.isHidden).to(beTrue())
                    expect(tableView?.isHidden).to(beFalse())
                }
                
                it("to a showing error state") {
                    mockPresenter.currentState.value = .showingError
                    expect(emptyView?.isHidden).to(beFalse())
                    expect(tableView?.isHidden).to(beTrue())
                }
                
            })
            
            context("updates", {
                
                it("the tableview after receiving new repositories") {
                    controller.updateList(withRepositories: [Repository()])
                    expect(tableView?.numberOfRows(inSection: 0)) == 1
                }
                
            })
            
            context("loadMoreView") {
                
                it("triggers the loadingMore state") {
                    loadMoreView?.loadingBlock?()
                    expect(mockPresenter.currentState.value) == RepositoryListState.loadingMore
                }
                
                it("has a normal value when showing repositories") {
                    mockPresenter.currentState.value = .showingRepositories
                    expect(loadMoreView?.currentState.value) == LoadMoreViewState.normal
                }
                
            }
            
        }
        
    }
    
}
