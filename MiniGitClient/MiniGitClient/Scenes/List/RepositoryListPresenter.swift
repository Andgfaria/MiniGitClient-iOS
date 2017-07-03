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

class RepositoryListPresenter : NSObject {
    
    weak var viewController : RepositoryListViewController? {
        didSet {
            bind()
        }
    }

    var interactor : RepositoryListInteractorProtocol? {
        didSet {
            bind()
        }
    }
    
    fileprivate var disposeBag = DisposeBag()
    
}


extension RepositoryListPresenter {
    
    fileprivate func bind() {
        if let interactor = interactor, let viewController = viewController {
            Observable.combineLatest(interactor.validationState.asObservable(), interactor.repositories.asObservable(), resultSelector: { (error, repositories) -> RepositoryListState in
                if let _ = error {
                    return .showingError
                }
                return repositories.count > 0 ? .showingRepositories : .showingError
            }).asObservable().skip(1).bind(to: viewController.currentState).addDisposableTo(disposeBag)
        }
    }
    
}

extension RepositoryListPresenter : RepositoryListPresenterProtocol {
    
    func loadRepositories() {
        interactor?.loadRepositories()
    }
    
    func registerTableView(_ tableView: UITableView) {
        tableView.register(RepositoryListTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
    }
    
    
}

extension RepositoryListPresenter : UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.repositories.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let repositoryCell = cell as? RepositoryListTableViewCell, let repository = interactor?.repositories.value[indexPath.row] {
            RepositoryListCellViewModel.configure(repositoryCell, with: repository)
        }
        return cell
    }
    
}
