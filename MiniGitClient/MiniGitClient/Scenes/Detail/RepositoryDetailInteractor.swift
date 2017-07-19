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
    
    var PullRequestsStoreType : PullRequestsStoreType = PullRequestsStore.shared
    
    var fetchedPullRequests : Variable<(APIRequestResult,[PullRequest])> = Variable((APIRequestResult.success,[PullRequest]()))
    
    fileprivate let disposeBag = DisposeBag()
    
}

extension RepositoryDetailInteractor : RepositoryDetailInteractorProtocol {
  
    func loadPullRequests(ofRepository repository : Repository) {
        PullRequestsStoreType.pullRequests(from: repository)
                         .subscribe(
                            onNext: { [weak self] in
                                self?.fetchedPullRequests.value = $0
                            },
                            onError: { [weak self] _ in
                                self?.fetchedPullRequests.value = (APIRequestResult.networkError, [PullRequest]())
                         })
                         .addDisposableTo(disposeBag)
    }
    
}
