//
//  RepositoryListTableViewModel.swift
//  MiniGitClient
//
//  Created by Andre Faria on 04/08/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit

class RepositoryListTableViewModel : NSObject {
    
    fileprivate var repositories = [Repository]()
    
    fileprivate weak var tableView : UITableView?
    
    weak var selectionHandler : TableViewSelectionHandler?
    
    
}

extension RepositoryListTableViewModel : RepositoryListTableViewModelType {
    
    func updateWith(repositories: [Repository]) {
        self.repositories = repositories
        tableView?.reloadData()
    }
    
}

extension RepositoryListTableViewModel : TableViewModel {
    
    func register(tableView: UITableView) {
        self.tableView = tableView
        tableView.register(RepositoryListTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(RepositoryListTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension RepositoryListTableViewModel : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(RepositoryListTableViewCell.self), for: indexPath)
        if let repositoryCell = cell as? RepositoryListTableViewCell {
            RepositoryListCellViewModel.configure(repositoryCell, with: repositories[indexPath.row])
        }
        return cell
    }
    
}

extension RepositoryListTableViewModel : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionHandler?.onSelection(ofIndex: indexPath.row, atSection: indexPath.section, withModel: repositories[indexPath.row])
    }
    
}
