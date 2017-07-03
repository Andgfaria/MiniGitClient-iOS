//
//  AppCoordinator.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 30/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator : Coordinator, UISplitViewControllerDelegate {
    
    private var splitViewController = UISplitViewController()
    
    private var master = RepositoryListViewController()
    
    private var masterPresenter = RepositoryListPresenter()
    
    func start() {
        masterPresenter.viewController = master
        master.presenter = masterPresenter
        let detail = UIViewController()
        let masterNavigationController = UINavigationController(rootViewController: master)
        let detailNavigationController = UINavigationController(rootViewController: detail)
        splitViewController.viewControllers = [masterNavigationController,detailNavigationController]
        splitViewController.delegate = self
        if let window = UIApplication.shared.delegate?.window {
            window?.rootViewController = splitViewController
            window?.makeKeyAndVisible()
        }
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
}
