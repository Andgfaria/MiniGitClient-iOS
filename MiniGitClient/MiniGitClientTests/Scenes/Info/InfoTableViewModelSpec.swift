/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import Quick
import Nimble
@testable import MiniGitClient

private class MockSelectionHandler : TableViewSelectionHandler {
    
    var selectedRow : Int?
    
    var selectedSection : Int?
    
    func onSelection(ofIndex index: Int, atSection section: Int, withModel model : Any?) {
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
                   expect(tableView.numberOfSections) == 2
                }
                
                it("returns 1 row for the first section") {
                   expect(tableView.numberOfRows(inSection: 0)) == 1
                }
                
                it("returns 2 rows for the second section") {
                    expect(tableView.numberOfRows(inSection: 1)) == 2
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
