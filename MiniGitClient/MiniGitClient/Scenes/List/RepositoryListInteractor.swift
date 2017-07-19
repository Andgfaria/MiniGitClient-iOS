//
//  RepositoryListInteractor.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 24/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Foundation
import RxSwift

protocol RepositoryListInteractorType : class {
    var repositoriesStore : RepositoriesStoreType { get set }
    var fetchResults : Variable<(APIRequestResult,[Repository])> { get set }
    func loadRepositories()
}

class RepositoryListInteractor {
    
    var repositoriesStore: RepositoriesStoreType = RepositoriesStore.shared
    
    var fetchResults : Variable<(APIRequestResult,[Repository])> = Variable((APIRequestResult.success,[Repository]()))
    
    fileprivate var currentPage = 1
    
    fileprivate let disposeBag = DisposeBag()
    
}


extension RepositoryListInteractor : RepositoryListInteractorType {
    
    func loadRepositories() {
        repositoriesStore.swiftRepositories(forPage: currentPage)
            .subscribe(onNext: { [weak self] requestResult, repositories in
                if requestResult != .success {
                    self?.fetchResults.value.0 = requestResult
                }
                else {
                    let newRepositories = repositories
                    if newRepositories.count > 0, let currentRepositories = self?.fetchResults.value.1 {
                        self?.currentPage += 1
                        self?.fetchResults.value = (APIRequestResult.success, currentRepositories + newRepositories)
                    }
                }
            },
            onError : { [weak self] _ in
                self?.fetchResults.value = (APIRequestResult.networkError,self?.fetchResults.value.1 ?? [Repository]())
            })
            .addDisposableTo(disposeBag)
    }
    
}
