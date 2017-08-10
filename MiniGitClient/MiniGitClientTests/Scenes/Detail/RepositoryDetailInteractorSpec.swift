//
//  RepositoryDetailInteractorSpec.swift
//  MiniGitClient
//
//  Created by Andre Faria on 20/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
import RxSwift
@testable import MiniGitClient

private enum MockError : Error {
    case mockedNetworkError, mockedInvalidJson
}

private class MockPullRequestsStore : PullRequestsStoreType {
    
    var mockedError : MockError?
    
    func pullRequests(from repository: Repository) -> Observable<RequestResult<[PullRequest]>> {
        if let error = mockedError {
            return error == .mockedNetworkError ? Observable.error(error) : Observable.just(RequestResult.failure(error))
        }
        var pullRequests = [PullRequest]()
        for _ in 1...10 {
            pullRequests.append(PullRequest())
        }
        return Observable.just(RequestResult.success(pullRequests))
    }
    
}

class RepositoryDetailInteractorSpec: QuickSpec {
    
    private let disposeBag = DisposeBag()
    
    override func spec() {
        
        context("The RepositoryDetailInteractor") { 
            
            var interactor = RepositoryDetailInteractor()
            
            var mockStore = MockPullRequestsStore()
            
            beforeEach {
                interactor = RepositoryDetailInteractor()
                mockStore = MockPullRequestsStore()
                interactor.store = mockStore
            }
            
            context("can", { 
                
                it("hold pull requests when successfull") {
                    var pullRequests : [PullRequest]?
                    interactor.pullRequests(ofRepository: Repository())
                              .subscribe(onNext: {
                                    pullRequests = $0
                              })
                              .addDisposableTo(self.disposeBag)
                    expect(pullRequests?.count) == 10
                }
                
            })
            
        }
        
    }
}
