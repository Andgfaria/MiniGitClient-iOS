//
//  InfoViewController.swift
//  MiniGitClient
//
//  Created by Andre Faria on 26/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    var tableView = UITableView(frame: CGRect.zero, style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

}


extension InfoViewController : ViewCodable {
    
    fileprivate func setup() {
        addViewsToHierarchy([tableView])
        setupConstraints()
    }
    
    func setupConstraints() {
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}
