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
    func repositories(fromPage page : Int) -> Observable<[Repository]>
}

class RepositoryListInteractor {
    
    var repositoriesStore: RepositoriesStoreType = RepositoriesStore.shared
    
    fileprivate let disposeBag = DisposeBag()
    
}


extension RepositoryListInteractor : RepositoryListInteractorType {
    
    func repositories(fromPage page : Int) -> Observable<[Repository]> {
        return repositoriesStore.swiftRepositories(forPage: page)
                .flatMap { requestResult, repositories -> Observable<[Repository]> in
                    if requestResult == .success {
                        return Observable.just(repositories)
                    }
                    else {
                        switch requestResult {
                        case .invalidEndpoint:
                            return Observable.error(APIRequestError.invalidEndpoint)
                        case .invalidJson:
                            return Observable.error(APIRequestError.invalidJson)
                        default:
                            return Observable.error(APIRequestError.networkError)
                        }
                    }
                }
    }
    
}
