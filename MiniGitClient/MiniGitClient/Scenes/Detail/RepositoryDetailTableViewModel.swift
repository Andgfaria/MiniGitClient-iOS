/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import UIKit

class RepositoryDetailTableViewModel : NSObject {
    
    fileprivate var pullRequests = [PullRequest]() {
        didSet {
            tableView?.reloadData()
        }
    }
    
    fileprivate weak var tableView : UITableView?
    
    weak var selectionHandler : TableViewSelectionHandler?
    
}

extension RepositoryDetailTableViewModel : RepositoryDetailTableViewModelType {
    
    func update(withPullRequests pullRequests: [PullRequest]) {
        self.pullRequests = pullRequests
    }
    
}

extension RepositoryDetailTableViewModel : TableViewModel {
    
    func register(tableView: UITableView) {
        self.tableView = tableView
        tableView.register(PullRequestTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(PullRequestTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension RepositoryDetailTableViewModel : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pullRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(PullRequestTableViewCell.self), for: indexPath)
        if let cell = cell as? PullRequestTableViewCell {
            PullRequestCellViewModel.configure(cell, withPullRequest: pullRequests[indexPath.row])
        }
        return cell
    }
    
}

extension RepositoryDetailTableViewModel : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectionHandler?.onSelection(ofIndex: indexPath.row, atSection: indexPath.section, withModel: pullRequests[indexPath.row])
    }
    
}
