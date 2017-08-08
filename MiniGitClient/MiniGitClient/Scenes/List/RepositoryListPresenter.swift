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
    
    var currentState = Variable(RepositoryListState.loadingFirst)
    
    var repositories = Variable([Repository]())
    
    fileprivate var currentPage = 1
    
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
        currentState.asObservable()
                    .subscribe(onNext: { [weak self] in
                        if $0 == .loadingFirst || $0 == .loadingMore {
                            self?.fetchRepositories()
                        }
                    })
                    .addDisposableTo(disposeBag)
    }
    
    private func fetchRepositories() {
        interactor?.repositories(fromPage: currentPage)
                    .subscribe(onNext: { [weak self] fetchedRepositories in
                        if fetchedRepositories.count > 0 {
                            guard let strongSelf = self else { return }
                            strongSelf.repositories.value = strongSelf.repositories.value + fetchedRepositories
                            strongSelf.currentPage += 1
                            strongSelf.currentState.value = .showingRepositories
                        }
                    },
                    onError: { [weak self] _ in
                        if let currentRepositories = self?.repositories.value, currentRepositories.count > 0 {
                            self?.currentState.value = .showingRepositories
                        }
                        else {
                            self?.currentState.value = .showingError
                        }
                    })
                    .addDisposableTo(disposeBag)
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
