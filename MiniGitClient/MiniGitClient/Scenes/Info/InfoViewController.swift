//
//  InfoViewController.swift
//  MiniGitClient
//
//  Created by Andre Faria on 26/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit

protocol InfoPresenterType : class, TableViewSelectionHandler {
    func onDismissButtonTapped(sender : InfoViewController)
}

protocol InfoTableViewModelType : TableViewModel, UITableViewDelegate {
    
    weak var selectionHandler : TableViewSelectionHandler? { get set }
    
}

class InfoViewController: UIViewController {
    
    fileprivate var tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    weak var presenter : InfoPresenterType?

    weak var tableViewModel : InfoTableViewModelType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = R.string.info.title()
        setupDoneButtonIfNeeded()
        setup(withViews: [tableView])
        tableViewModel?.register(tableView: tableView)
    }

}

extension InfoViewController {
    
    fileprivate func setupDoneButtonIfNeeded() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDoneTap))
    }
    
    func handleDoneTap() {
        presenter?.onDismissButtonTapped(sender: self)
    }
    
}


extension InfoViewController : ViewCodable {
    
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
