//
//  InfoViewController.swift
//  MiniGitClient
//
//  Created by Andre Faria on 26/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit

protocol InfoPresenterType : class, UITableViewDataSource, UITableViewDelegate {
    func registerTableView(_ tableView : UITableView)
    func onDismissButtonTapped(sender : InfoViewController)
}

class InfoViewController: UIViewController {
    
    fileprivate var tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    var presenter : InfoPresenterType?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = R.string.info.title()
        setup()
        presenter?.registerTableView(tableView)
    }

}

extension InfoViewController {
    
    fileprivate func setupDoneButtonIfNeeded() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDoneTap))
    }
    
    func handleDoneTap() {
        presenter?.onDismissButtonTapped(sender: self)
    }
    
}


extension InfoViewController : ViewCodable {
    
    fileprivate func setup() {
        addViewsToHierarchy([tableView])
        setupConstraints()
        setupDoneButtonIfNeeded()
        setupAccessibilityIdentifiers()
    }
    
    func setupConstraints() {
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupAccessibilityIdentifiers() {
        tableView.accessibilityIdentifier = "InfoTableView"
        self.navigationItem.rightBarButtonItem?.accessibilityIdentifier = "InfoDoneButton"
    }
    
}
