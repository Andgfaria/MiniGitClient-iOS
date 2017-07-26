//
//  RepositoryListPresenter.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 30/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol RepositoryListRouterType : class {
    func presenter(_ presenter : RepositoryListPresenterType, didSelectRepository repository : Repository)
}

class RepositoryListPresenter : NSObject {
    
    weak var viewController : RepositoryListViewController? {
        didSet {
            bind()
        }
    }

    var interactor : RepositoryListInteractorType? {
        didSet {
            bind()
        }
    }
    
    weak var router : RepositoryListRouterType?
    
    fileprivate var disposeBag = DisposeBag()
    
}


extension RepositoryListPresenter {
    
    fileprivate func bind() {
        if let interactor = interactor, let viewController = viewController {
            interactor.fetchResults.asObservable().skip(1)
                       .map { requestResult, repositories in
                            if requestResult != .success {
                                return RepositoryListState.showingError
                            }
                            return repositories.count > 0 ? RepositoryListState.showingRepositories : RepositoryListState.showingError
                        }
                        .bind(to: viewController.currentState)
                        .addDisposableTo(disposeBag)
        }
    }
    
}

extension RepositoryListPresenter : RepositoryListPresenterType {
    
    func loadRepositories() {
        interactor?.loadRepositories()
    }
    
    func registerTableView(_ tableView: UITableView) {
        tableView.register(RepositoryListTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(RepositoryListTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
}

extension RepositoryListPresenter : UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.fetchResults.value.1.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(RepositoryListTableViewCell.self), for: indexPath)
        if let repositoryCell = cell as? RepositoryListTableViewCell, let repository = interactor?.fetchResults.value.1[indexPath.row] {
            RepositoryListCellViewModel.configure(repositoryCell, with: repository)
        }
        return cell
    }
    
}

extension RepositoryListPresenter : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let repositories = interactor?.fetchResults.value.1 {
            router?.presenter(self, didSelectRepository: repositories[indexPath.row])
        }
    }
    
}
