//
//  RepositoryDetailTableViewModelSpec.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 06/08/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
@testable import MiniGitClient

private class MockSelectionHandler : TableViewSelectionHandler {
    
    var didReceivePullRequest = false
    
    func onSelection(ofIndex index : Int, atSection section : Int, withModel model : Any?) {
        didReceivePullRequest = model is PullRequest
    }
}

class RepositoryDetailTableViewModelSpec: QuickSpec {
    
    override func spec() {
        
        describe("The RepositoryDetailTableViewModel") { 
            
            var tableViewModel = RepositoryDetailTableViewModel()
            
            var tableView = UITableView()
            
            var mockSelectionHandler = MockSelectionHandler()
            
            var testPullRequests = [PullRequest]()
            
            beforeEach {
                tableViewModel = RepositoryDetailTableViewModel()
                tableView = UITableView()
                mockSelectionHandler = MockSelectionHandler()
                testPullRequests = [PullRequest]()
                for _ in 0..<10 {
                    testPullRequests.append(PullRequest())
                }
                tableViewModel.selectionHandler = mockSelectionHandler
                tableViewModel.register(tableView: tableView)
                tableViewModel.update(withPullRequests: testPullRequests)
            }
            
            context("as an UITableViewDataSource", { 
                
                it("returns 1 section") {
                    expect(tableView.numberOfSections) == 1
                }
                
                it("returns the number of pull requests as the number of rows") {
                    expect(tableView.numberOfRows(inSection: 0)) == testPullRequests.count
                }
                
                it("returns a PullRequestTableViewCell for each row") {
                    expect(tableViewModel.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))).to(beAKindOf(PullRequestTableViewCell.self))
                }
                
            })
            
            context("as an UITableViewDelegate", { 
                
                it("passes the selected pull request to the selection handler") {
                    tableViewModel.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
                    expect(mockSelectionHandler.didReceivePullRequest).to(beTrue())
                }
                
            })
            
        }
        
    }
    
}
