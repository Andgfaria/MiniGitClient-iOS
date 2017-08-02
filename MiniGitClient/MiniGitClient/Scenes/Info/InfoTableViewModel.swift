//
//  InfoTableViewModel.swift
//  MiniGitClient
//
//  Created by Andre Faria on 02/08/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit

class InfoTableViewModel : NSObject {
    
    weak var selectionHandler : TableViewSelectionHandler?

}

extension InfoTableViewModel : InfoTableViewModelType {
    
    func register(tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }

}

extension InfoTableViewModel : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        switch indexPath.section {
        case 0:
            InfoMeCellViewModel.configureCell(cell)
        case 1:
            let text = indexPath.row == 0 ? R.string.info.repositoryLink() : R.string.info.contactLink()
            InfoLinkCellViewModel.configureCell(cell, withText: text, andColor: tableView.tintColor)
        default:
            break
        }
        return cell
    }
    
}

extension InfoTableViewModel : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 56 : 44
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? R.string.info.meTitle() : nil
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return section == 0 ? R.string.info.meDescription() : nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectionHandler?.onSelection(ofIndex: indexPath.row, atSection: indexPath.section)
    }
    
}
