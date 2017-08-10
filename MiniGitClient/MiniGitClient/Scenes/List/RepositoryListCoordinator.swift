/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import UIKit

fileprivate struct ListScene {
    let viewController = RepositoryListViewController()
    let presenter = RepositoryListPresenter()
    let interactor = RepositoryListInteractor()
    let tableViewModel = RepositoryListTableViewModel()
    
    init() {
        presenter.interactor = interactor
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
