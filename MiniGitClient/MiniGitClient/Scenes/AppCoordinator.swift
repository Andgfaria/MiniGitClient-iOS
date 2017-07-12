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
        listScene.presenter.router = self
        splitViewController.view.backgroundColor = .white
        let masterNavigationController = UINavigationController(rootViewController: listScene.viewController)
        splitViewController.viewControllers = [masterNavigationController]
        splitViewController.delegate = self
        if let window = UIApplication.shared.delegate?.window {
            window?.rootViewController = splitViewController
            window?.makeKeyAndVisible()
        }
    }
    
}

extension AppCoordinator : RepositoryListRouter {
    
    func presenter(_ presenter: RepositoryListPresenterProtocol, didSelectRepository repository: Repository) {
        let navController = UINavigationController(rootViewController: UIViewController(nibName: nil, bundle: nil))
        splitViewController.showDetailViewController(navController, sender: self)
    }
    
}

extension AppCoordinator : UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
}
