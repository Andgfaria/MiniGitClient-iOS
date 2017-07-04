//
//  RepositoryListViewControllerSpec.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 04/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
@testable import MiniGitClient

class MockPresenter : NSObject, RepositoryListPresenterProtocol {
    
    var loadRepositoriesCount = 0
    
    var registerTableViewCount = 0
    
    weak var viewController : RepositoryListViewController?
    
    func loadRepositories() {
        loadRepositoriesCount += 1
    }
    
    func registerTableView(_ tableView : UITableView) {
        registerTableViewCount += 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}


class RepositoryListViewControllerSpec: QuickSpec {

    override func spec() {
        
        describe("The RepositoryListViewController") {
            
            var controller = RepositoryListViewController(nibName: nil, bundle: nil)
            
            var emptyView : EmptyView?
            
            var tableView : UITableView?
            
            var mockPresenter = MockPresenter()
            
            beforeEach {
                mockPresenter = MockPresenter()
                controller = RepositoryListViewController(nibName: nil, bundle: nil)
                controller.presenter = mockPresenter
                _ = controller.view
                emptyView = controller.view.subviews.flatMap { $0 as? EmptyView }.first
                tableView = controller.view.subviews.flatMap { $0 as? UITableView }.first
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
                
            })
            
            context("changes", { 
                
                it("to a loading first state") {
                    controller.currentState.value = .loadingFirst
                    expect(emptyView?.isHidden).to(beFalse())
                    expect(tableView?.isHidden).to(beTrue())
                }
                
                it("to a loading more state") {
                    controller.currentState.value = .loadingMore
                    expect(emptyView?.isHidden).to(beTrue())
                    expect(tableView?.isHidden).to(beFalse())
                }
                
                it("to a showing repositories state") {
                    controller.currentState.value = .showingRepositories
                    expect(emptyView?.isHidden).to(beTrue())
                    expect(tableView?.isHidden).to(beFalse())
                }
                
                it("to a showing error state") {
                    controller.currentState.value = .showingError
                    expect(emptyView?.isHidden).to(beFalse())
                    expect(tableView?.isHidden).to(beTrue())
                }
                
            })
            
            context("presenter", { 
                
                it("has it methods called when the view is loaded") {
                    expect(mockPresenter.loadRepositoriesCount) == 1
                    expect(mockPresenter.registerTableViewCount) == 1
                }
                
                it("loads repositories when the controller changes to a loading first state") {
                    let currentLoadRepositoriesCount = mockPresenter.loadRepositoriesCount
                    controller.currentState.value = .loadingFirst
                    expect(mockPresenter.loadRepositoriesCount) == currentLoadRepositoriesCount + 1
                }
                
                it("loads repositories when the controller changes to a loading more state") {
                    let currentLoadRepositoriesCount = mockPresenter.loadRepositoriesCount
                    controller.currentState.value = .loadingMore
                    expect(mockPresenter.loadRepositoriesCount) == currentLoadRepositoriesCount + 1
                }
                
            })
            
        }
        
    }
    
}
