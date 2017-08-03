//
//  InfoTableViewModelSpec.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 02/08/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
@testable import MiniGitClient

private class MockSelectionHandler : TableViewSelectionHandler {
    
    var selectedRow : Int?
    
    var selectedSection : Int?
    
    func onSelection(ofIndex index: Int, atSection section: Int) {
        selectedRow = index
        selectedSection = section
    }
    
}

class InfoTableViewModelSpec: QuickSpec {
    
    override func spec() {
        
        describe("The InfoTableViewModel") {
            
            var tableViewModel = InfoTableViewModel()
            
            var mockSelectionHandler = MockSelectionHandler()
            
            var tableView = UITableView(frame: .zero)
            
            beforeEach {
                tableViewModel = InfoTableViewModel()
                mockSelectionHandler = MockSelectionHandler()
                tableViewModel.selectionHandler = mockSelectionHandler
                tableView = UITableView(frame: .zero)
                tableViewModel.register(tableView: tableView)
            }
            
            context("as an UITableViewDataSource", { 
                
                it("returns 2 sections") {
                    expect(tableViewModel.numberOfSections(in: tableView)) == 2
                }
                
                it("returns 1 row for the first section") {
                    expect(tableViewModel.tableView(tableView, numberOfRowsInSection: 0)) == 1
                }
                
                it("returns 2 rows for the second section") {
                    expect(tableViewModel.tableView(tableView, numberOfRowsInSection: 0)) == 1
                }
                
                it("returns basic cells for each row") {
                    expect(tableViewModel.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))).to(beAKindOf(UITableViewCell.self))
                    expect(tableViewModel.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 1))).to(beAKindOf(UITableViewCell.self))
                    expect(tableViewModel.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 1))).to(beAKindOf(UITableViewCell.self))
                }
                
            })
            
            context("as an UITableViewDelegate", { 
                
                it("returns a height of 56 for the first section") {
                    expect(tableViewModel.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: 0))) == 56
                }
                
                it("returns a height of 44 for the second section") {
                    expect(tableViewModel.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: 1))) == 44
                    expect(tableViewModel.tableView(tableView, heightForRowAt: IndexPath(row: 1, section: 1))) == 44
                }
                
                it("returns the me title for the first section header") {
                    expect(tableViewModel.tableView(tableView, titleForHeaderInSection: 0)) == R.string.info.meTitle()
                }
                
                it("returns no title for the second section header") {
                    expect(tableViewModel.tableView(tableView, titleForHeaderInSection: 1)).to(beNil())
                }
                
                it("returns the me descripton for the first section footer") {
                    expect(tableViewModel.tableView(tableView, titleForFooterInSection: 0)) == R.string.info.meDescription()
                }
                
                it("returns no title for the second section footer") {
                    expect(tableViewModel.tableView(tableView, titleForFooterInSection: 1)).to(beNil())
                }
                
            })
            
            context("selection handler", { 
                
                it("is called when a cell is selected") {
                    tableViewModel.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 1))
                    expect(mockSelectionHandler.selectedRow) == 0
                    expect(mockSelectionHandler.selectedSection) == 1
                }
                
            })
            
        }
        
        
    }
    
}
