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
    func onRepositorySelection(_ repository : Repository)
    func onInfoScreenRequest()
}

class RepositoryListPresenter : NSObject {
    
    var currentState = Variable(RepositoryListState.loadingFirst)
    
    var repositories = Variable([Repository]())
    
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
            interactor.fetchResults
                      .asObservable()
                      .skip(1)
                      .subscribe(onNext: { [weak self] requestResult, repositories in
                            if requestResult == .success && repositories.count > 0{
                                self?.repositories.value = repositories
                                self?.currentState.value = .showingRepositories
                            }
                            else {
                                self?.currentState.value = .showingError
                            }
                      })
                      .addDisposableTo(disposeBag)
            currentState.asObservable()
                        .subscribe(onNext: { [weak self] in
                            if $0 == .loadingFirst || $0 == .loadingMore {
                                self?.interactor?.loadRepositories()
                            }
                        })
                        .addDisposableTo(disposeBag)
        }
    }
    
}

extension RepositoryListPresenter : RepositoryListPresenterType {
    
    func onInfoButtonTap() {
        router?.onInfoScreenRequest()
    }
    
}

extension RepositoryListPresenter : TableViewSelectionHandler {
    
    func onSelection(ofIndex index: Int, atSection section: Int, withModel model: Any?) {
        if let repository = model as? Repository {
            router?.onRepositorySelection(repository)
        }
    }
    
}
