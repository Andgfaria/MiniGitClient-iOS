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
