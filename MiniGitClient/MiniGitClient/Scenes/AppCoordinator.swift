//
//  AppCoordinator.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 30/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator {
    
    fileprivate var splitViewController = MainSplitViewController()
    
    fileprivate var repositoryListCoordinator : RepositoryListCoordinator?

}

extension AppCoordinator : Coordinator {
    
    func start() {
        splitViewController.delegate = self
        repositoryListCoordinator = RepositoryListCoordinator(splitViewController: splitViewController)
        repositoryListCoordinator?.start()
        if let window = UIApplication.shared.delegate?.window {
            window?.rootViewController = splitViewController
            window?.makeKeyAndVisible()
        }
    }
    
}

extension AppCoordinator : UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return false
    }
    
}
