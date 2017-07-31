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
                presenter.registerTableView(tableView)
                presenter.router = router
            }
            
            context("as an UITableViewDataSource", { 
                
                it("returns 2 sections") {
                    expect(presenter.numberOfSections(in: tableView)) == 2
                }
                
                it("returns 1 row for the first section") {
                    expect(presenter.tableView(tableView, numberOfRowsInSection: 0)) == 1
                }
                
                it("returns 2 rows for the second section") {
                    expect(presenter.tableView(tableView, numberOfRowsInSection: 0)) == 1
                }
                
                it("returns basic cells for each row") {
                    expect(presenter.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))).to(beAKindOf(UITableViewCell.self))
                    expect(presenter.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 1))).to(beAKindOf(UITableViewCell.self))
                    expect(presenter.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 1))).to(beAKindOf(UITableViewCell.self))
                }
                
            })
            
            context("as an UITableViewDelegate", { 
                
                it("returns a height of 56 for the first section") {
                    expect(presenter.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: 0))) == 56
                }
                
                it("returns a height of 44 for the second section") {
                    expect(presenter.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: 1))) == 44
                    expect(presenter.tableView(tableView, heightForRowAt: IndexPath(row: 1, section: 1))) == 44
                }
                
                it("returns the me title for the first section header") {
                    expect(presenter.tableView(tableView, titleForHeaderInSection: 0)) == R.string.info.meTitle()
                }
                
                it("returns no title for the second section header") {
                    expect(presenter.tableView(tableView, titleForHeaderInSection: 1)).to(beNil())
                }
                
                it("returns the me descripton for the first section footer") {
                    expect(presenter.tableView(tableView, titleForFooterInSection: 0)) == R.string.info.meDescription()
                }
                
                it("returns no title for the second section footer") {
                    expect(presenter.tableView(tableView, titleForFooterInSection: 1)).to(beNil())
                }
                
            })
            
            context("router") {
                
                it("opens the GitHub page when the first row of the second section is selected") {
                    presenter.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 1))
                    expect(router.didOpenGitHubPage).to(beTrue())
                }
                
                it("opens the mail compose UI when the second row of the second section is selected") {
                    presenter.tableView(tableView, didSelectRowAt: IndexPath(row: 1, section: 1))
                    expect(router.didOpenMailCompose).to(beTrue())
                }
                
            }
            
        }
        
    }
    
}
