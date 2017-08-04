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

enum RepositoryListState {
    case loadingFirst, showingRepositories, loadingMore, showingError
}


protocol RepositoryListRouterType : class {
    func presenter(_ presenter : RepositoryListPresenterType, didSelectRepository repository : Repository)
    func presenter(_ presenter : RepositoryListPresenterType, didHandleInfoTapWithItem item : UIBarButtonItem)
}

class RepositoryListPresenter : NSObject {
    
    var currentState = Variable(RepositoryListState.loadingFirst)
    
    weak var viewController : RepositoryListViewController?

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
        if let interactor = interactor {
            interactor.fetchResults.asObservable().skip(1)
                       .map { requestResult, repositories in
                            if requestResult != .success {
                                return RepositoryListState.showingError
                            }
                            return repositories.count > 0 ? RepositoryListState.showingRepositories : RepositoryListState.showingError
                        }
                        .bind(to: currentState)
                        .addDisposableTo(disposeBag)
            currentState.asObservable()
                        .subscribe(onNext: { [weak self] in
                            if $0 == .loadingFirst || $0 == .loadingMore {
                                self?.interactor?.loadRepositories()
                            }
                            else if $0 == .showingRepositories, let repositories = self?.interactor?.fetchResults.value.1 {
                                self?.viewController?.updateList(withRepositories: repositories)
                            }
                        })
                        .addDisposableTo(disposeBag)
        }
    }
    
}

extension RepositoryListPresenter : RepositoryListPresenterType {
    
    func handleInfoButtonTap(barButtonItem: UIBarButtonItem) {
        router?.presenter(self, didHandleInfoTapWithItem: barButtonItem)
    }
    
}

extension RepositoryListPresenter : TableViewSelectionHandler {
    
    func onSelection(ofIndex index: Int, atSection section: Int, withModel model: Any?) {
        if let repository = model as? Repository {
            router?.presenter(self, didSelectRepository: repository)
        }
    }
    
}
