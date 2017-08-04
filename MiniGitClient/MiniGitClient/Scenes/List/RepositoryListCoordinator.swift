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
    let tableViewModel = RepositoryListTableViewModel()
    
    init() {
        presenter.interactor = interactor
        presenter.viewController = viewController
        viewController.presenter = presenter
        viewController.tableViewModel = tableViewModel
        tableViewModel.selectionHandler = presenter
    }
}

class RepositoryListCoordinator {
    
    fileprivate let scene = ListScene()
    
    fileprivate var repositoryDetailCoordinator : RepositoryDetailCoordinator?
    
    weak var splitViewController : UISplitViewController?
    
    var infoCoordinator : InfoCoordinator?
    
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
    
    func onRepositorySelection(_ repository: Repository) {
        guard let splitViewController = splitViewController else { return }
        repositoryDetailCoordinator = RepositoryDetailCoordinator(repository : repository, splitViewController: splitViewController)
        repositoryDetailCoordinator?.start()
    }
    
    
    func onInfoScreenRequest() {
        if let master = splitViewController?.viewControllers.first, let sender = scene.viewController.navigationItem.leftBarButtonItem {
            infoCoordinator = InfoCoordinator(viewController: master, senderItem: sender)
            infoCoordinator?.start()
        }
    }
    
}
