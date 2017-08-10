/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

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
