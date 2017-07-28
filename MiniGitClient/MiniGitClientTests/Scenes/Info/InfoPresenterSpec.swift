//
//  InfoPresenterSpec.swift
//  MiniGitClient
//
//  Created by Andre Faria on 28/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

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
            
            var tableView = UITableView(frame: .zero)
            
            beforeEach {
                presenter = InfoPresenter()
                router = MockRouter()
                tableView = UITableView(frame: .zero)
                presenter.router = router
                presenter.registerTableView(tableView)
            }
            
            context("as an UITableViewDataSource", { 
                
                it("returns 2 sections") {
                    expect(tableView.numberOfSections) == 2
                }
                
                it("returns 1 row for the first section") {
                    expect(tableView.numberOfRows(inSection: 0)) == 1
                }
                
                it("returns 2 rows for the second section") {
                    expect(tableView.numberOfRows(inSection: 1)) == 2
                }
                
                it("returns a default UITableViewCell for each row") {
                }
                
            })
            
        }
        
    }
    
}
