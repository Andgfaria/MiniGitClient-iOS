//
//  RepositoryListInteractor.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 24/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Foundation
import RxSwift

class RepositoryListInteractor {
    
    var repositoriesStore: RepositoriesStoreType = RepositoriesStore.shared
    
}


extension RepositoryListInteractor : RepositoryListInteractorType {
    
    func repositories(fromPage page : Int) -> Observable<[Repository]> {
        return repositoriesStore.swiftRepositories(forPage: page)
               .flatMap { requestResult -> Observable<[Repository]> in
                    switch(requestResult) {
                    case .success(let repositories):
                        return Observable.just(repositories)
                    case .failure(let error):
                        return Observable.error(error)
                    }
                }
    }
    
}
