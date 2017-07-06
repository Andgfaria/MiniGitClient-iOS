//
//  AppCoordinator.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 30/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Foundation
import UIKit

fileprivate struct ListScene {
    let viewController = RepositoryListViewController()
    let presenter = RepositoryListPresenter()
    let interactor = RepositoryListInteractor()
    
    init() {
        presenter.interactor = interactor
        presenter.viewController = viewController
        viewController.presenter = presenter
    }
}

class AppCoordinator {
    fileprivate var splitViewController = UISplitViewController()
    fileprivate let listScene = ListScene()
}

extension AppCoordinator : Coordinator {
    
    func start() {
        let detail = UIViewController()
        let masterNavigationController = UINavigationController(rootViewController: listScene.viewController)
        let detailNavigationController = UINavigationController(rootViewController: detail)
        splitViewController.viewControllers = [masterNavigationController,detailNavigationController]
        splitViewController.delegate = self
        if let window = UIApplication.shared.delegate?.window {
            window?.rootViewController = splitViewController
            window?.makeKeyAndVisible()
        }
    }
    
}

extension AppCoordinator : UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
}
