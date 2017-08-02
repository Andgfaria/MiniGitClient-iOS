//
//  TableViewModel.swift
//  MiniGitClient
//
//  Created by Andre Faria on 02/08/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit

protocol TableViewModel : class, UITableViewDataSource {
    func register(tableView : UITableView)
}


protocol TableViewSelectionHandler : class {
    func onSelection(ofIndex index : Int, atSection section : Int)
}
