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
