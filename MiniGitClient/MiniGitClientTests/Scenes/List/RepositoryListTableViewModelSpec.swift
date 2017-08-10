//
//  RepositoryListTableViewModelSpec.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 05/08/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
@testable import MiniGitClient

private class MockSelectionHandler : TableViewSelectionHandler {
    
    var didReceiveRepository = false
    
    func onSelection(ofIndex index: Int, atSection section: Int, withModel model: Any?) {
        didReceiveRepository = model is Repository
    }
    
}

class RepositoryListTableViewModelSpec: QuickSpec {
    
    override func spec() {
        
        describe("The RepositoryListTableViewModel") {
            
            var tableViewModel = RepositoryListTableViewModel()
            
            var tableView = UITableView()
            
            var mockedSelectionHandler = MockSelectionHandler()
            
            var testRepositories = [Repository]()
            
            beforeEach {
                tableViewModel = RepositoryListTableViewModel()
                tableView = UITableView()
                mockedSelectionHandler = MockSelectionHandler()
                tableViewModel.selectionHandler = mockedSelectionHandler
                tableViewModel.register(tableView: tableView)
                testRepositories = [Repository]()
                for _ in 0..<10 {
                    testRepositories.append(Repository())
                }
                tableViewModel.updateWith(repositories: testRepositories)
            }
            
            context("as an UITableViewDataSource", { 
                
                it("returns 1 section") {
                    expect(tableView.numberOfSections) == 1
                }
                
                it("returns the number of total repositories as the number of rows") {
                    expect(tableView.numberOfRows(inSection: 0)) == testRepositories.count
                }
                
                it("return a RepositoryTableViewCell for each row") {
                    expect(tableViewModel.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))).to(beAKindOf(RepositoryListTableViewCell.self))
                }
                
            })
            
            context("as an UITableViewDelegate", { 
                
                it("passes the selection handler the selected repository") {
                    tableViewModel.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
                    expect(mockedSelectionHandler.didReceiveRepository).to(beTrue())
                }
                
            })
            
        }
        
    }
    
}
