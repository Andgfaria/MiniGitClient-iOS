//
//  RepositoryListCoordinator.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 15/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

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

class RepositoryListCoordinator {
    
    fileprivate let scene = ListScene()
    
    fileprivate var repositoryDetailCoordinator : RepositoryDetailCoordinator?
    
    weak var splitViewController : UISplitViewController?
    
    required init(splitViewController : UISplitViewController) {
        self.splitViewController = splitViewController
    }
    
}

extension RepositoryListCoordinator : Coordinator {
    
    func start() {
        scene.presenter.router = self
        let navigationController = UINavigationController(rootViewController: scene.viewController)
        splitViewController?.viewControllers = [navigationController]
        splitViewController?.view.backgroundColor = .white
    }
    
}

extension RepositoryListCoordinator : RepositoryListRouterType {
    
    func presenter(_ presenter : RepositoryListPresenterType, didSelectRepository repository : Repository) {
        guard let splitViewController = splitViewController else { return }
        repositoryDetailCoordinator = RepositoryDetailCoordinator(repository : repository, splitViewController: splitViewController)
        repositoryDetailCoordinator?.start()
    }
    
}
