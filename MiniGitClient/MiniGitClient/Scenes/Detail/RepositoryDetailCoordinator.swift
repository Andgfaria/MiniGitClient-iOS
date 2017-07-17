//
//  RepositoryDetailCoordinator.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 15/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit

fileprivate struct RepositoryDetailScene {
    
    let repository : Repository
    let viewController = RepositoryDetailViewController()
    let presenter : RepositoryDetailPresenter
    let interactor = RepositoryDetailInteractor()
    
    init(repository : Repository) {
        self.repository = repository
        presenter = RepositoryDetailPresenter(repository: self.repository)
        presenter.viewController = viewController
        presenter.interactor = interactor
        viewController.presenter = presenter
    }
    
}

struct RepositoryDetailCoordinator {
    
    fileprivate let scene : RepositoryDetailScene
    
    fileprivate weak var splitViewController : UISplitViewController?
    
    init(repository: Repository, splitViewController : UISplitViewController) {
        self.splitViewController = splitViewController
        self.scene = RepositoryDetailScene(repository: repository)
    }
    
}

extension RepositoryDetailCoordinator : Coordinator {
    
    func start() {
        guard let splitViewController = splitViewController else { return }
        let navController = UINavigationController(rootViewController: scene.viewController)
        splitViewController.showDetailViewController(navController, sender: self)
    }
    
}
