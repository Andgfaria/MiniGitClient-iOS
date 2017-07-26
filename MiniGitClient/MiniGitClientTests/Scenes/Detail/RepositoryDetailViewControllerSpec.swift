//
//  RepositoryDetailViewControllerSpec.swift
//  MiniGitClient
//
//  Created by Andre Faria on 24/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
@testable import MiniGitClient

private class MockPresenter : NSObject, RepositoryDetailPresenterType {
    
    weak var viewController : RepositoryDetailViewController?
    
    var didConfigureHeader = false
    
    var didRegisterTableView = false
    
    var didLoadPullRequests = false
    
    var didReturnShareItems = false
    
    var didReturnCells = false
    
    func configureHeader(_ header: RepositoryDetailHeaderView) {
        didConfigureHeader = true
    }
    
    func registerTableView(_ tableView: UITableView) {
        didRegisterTableView = true
        tableView.dataSource = self
    }
    
    func loadPullRequests() {
        didLoadPullRequests = true
    }
    
    var shareItems: [Any] {
        didReturnShareItems = true
        return []
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        didReturnCells = true
        return UITableViewCell(frame: CGRect.zero)
    }
}



class RepositoryDetailViewControllerSpec: QuickSpec {
    
    override func spec() {
        
        describe("The RepositoryDetailViewController") { 
            
            var viewController = RepositoryDetailViewController(nibName: nil, bundle: nil)
            
            var mockPresenter = MockPresenter()
            
            beforeEach {
                viewController = RepositoryDetailViewController(nibName: nil, bundle: nil)
                mockPresenter = MockPresenter()
                viewController.presenter = mockPresenter
                viewController.view.layoutIfNeeded()
            }
            
            context("has", { 
                
                it("a table view") {
                    expect(viewController.tableView).toNot(beNil())
                }
                
                it("a header view") {
                    expect(viewController.headerView).toNot(beNil())
                }
                
            })
            
            context("changes", { 
                
                it("to a loading state and loads pull requests") {
                    viewController.headerView.currentState.value = .loading
                    expect(mockPresenter.didLoadPullRequests).to(beTrue())
                }
                
                it("to a loaded state and reloads the tableview") {
                    viewController.headerView.currentState.value = .loaded
                    expect(mockPresenter.didReturnCells).to(beTrue())
                }
                
            })
            
            context("presenter", { 
                
                it("configures the header") {
                    expect(mockPresenter.didConfigureHeader).to(beTrue())
                }
                
                it("register the tableview") {
                    expect(mockPresenter.didRegisterTableView).to(beTrue())
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
