//
//  RepositoryDetailTableViewModel.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 05/08/17.
//  Copyright © 2017 AGF. All rights reserved.
//

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
