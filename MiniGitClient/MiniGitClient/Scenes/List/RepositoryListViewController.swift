//
//  RepositoryListViewController.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 30/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit

class RepositoryListViewController: UIViewController {
    
    fileprivate var emptyView = EmptyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


extension RepositoryListViewController : ViewCodable {
    
    fileprivate func setup() {
        addViewsToHierarchy([emptyView])
        setupConstraints()
        setupStyles()
    }
    

    func setupConstraints() {
        emptyView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        emptyView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        emptyView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        emptyView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func setupStyles() {
        self.view.backgroundColor = .white
    }
    
}
