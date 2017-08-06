//
//  RepositoryDetailCoordinator.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 15/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit
import SafariServices

fileprivate struct RepositoryDetailScene {
    
    let repository : Repository
    let viewController = RepositoryDetailViewController()
    let presenter : RepositoryDetailPresenter
    let interactor = RepositoryDetailInteractor()
    let tableViewModel = RepositoryDetailTableViewModel()
    
    init(repository : Repository) {
        self.repository = repository
        presenter = RepositoryDetailPresenter(repository: self.repository)
        presenter.viewController = viewController
        presenter.interactor = interactor
        tableViewModel.selectionHandler = presenter
        viewController.presenter = presenter
        viewController.tableViewModel = tableViewModel
    }
    
}

class RepositoryDetailCoordinator {
    
    fileprivate let scene : RepositoryDetailScene
    
    fileprivate weak var splitViewController : UISplitViewController?
    
    required init(repository: Repository, splitViewController : UISplitViewController) {
        self.splitViewController = splitViewController
        self.scene = RepositoryDetailScene(repository: repository)
    }
    
}

extension RepositoryDetailCoordinator : Coordinator {
    
    func start() {
        guard let splitViewController = splitViewController else { return }
        let navController = UINavigationController(rootViewController: scene.viewController)
        splitViewController.showDetailViewController(navController, sender: self)
        scene.presenter.router = self
    }
    
}


extension RepositoryDetailCoordinator : RepositoryDetailRouterType {
    
    func onPullRequestSelection(_ pullRequest: PullRequest) {
        if let url = pullRequest.url, let splitViewController = splitViewController ,UIApplication.shared.canOpenURL(url) {
            let safariViewController = SFSafariViewController(url: url)
            safariViewController.modalPresentationStyle = .pageSheet
            splitViewController.present(safariViewController, animated: true, completion: nil)
        }
    }
    
}
