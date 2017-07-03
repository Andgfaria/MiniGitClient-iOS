//
//  RepositoryListInteractor.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 24/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Foundation
import RxSwift

protocol RepositoryListInteractorProtocol : class {
    var repositoriesStore : RepositoriesStore { get set }
    var repositories : Variable<[Repository]> { get set }
    var validationState : Variable<Error?> { get set }
    func loadRepositories()
}

class RepositoryListInteractor : RepositoryListInteractorProtocol {
    
    var repositoriesStore: RepositoriesStore = MainRepositoriesStore.shared
    
    var repositories: Variable<[Repository]> = Variable([])
    
    var validationState : Variable<Error?> = Variable(nil)
    
    private var currentPage = 1
    
    private let disposeBag = DisposeBag()
    
    func loadRepositories() {
        repositoriesStore.swiftRepositories(forPage: currentPage)
                         .subscribe(onNext: { [weak self] in
                            let newRepositories = $0
                            if newRepositories.count > 0 {
                                self?.currentPage += 1
                                self?.validationState.value = nil
                                self?.repositories.value += newRepositories
                            }
                         },
                        onError : { [weak self] in
                                self?.validationState.value = $0
                         })
                         .addDisposableTo(disposeBag)
    }
    
}
