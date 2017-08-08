//
//  RepositoryDetailInteractor.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 16/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Foundation
import RxSwift

class RepositoryDetailInteractor {
    
    var store : PullRequestsStoreType = PullRequestsStore.shared
    
}

extension RepositoryDetailInteractor : RepositoryDetailInteractorType {
    
    func pullRequests(ofRepository repository : Repository) -> Observable<[PullRequest]> {
        return store.pullRequests(from: repository)
                    .flatMap { requestResult -> Observable<[PullRequest]> in
                        switch requestResult {
                        case .success(let pullRequests):
                            return Observable.just(pullRequests)
                        case .failure(let error):
                            return Observable.error(error)
                    }
            }
    }
  
}
