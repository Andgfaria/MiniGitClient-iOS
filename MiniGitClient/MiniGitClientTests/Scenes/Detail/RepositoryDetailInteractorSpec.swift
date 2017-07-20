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

fileprivate enum MockError : Error {
    case mockedNetworkError, mockedInvalidJson
}

private class MockPullRequestsStore : PullRequestsStoreType {
    
    var mockedError : MockError?
    
    func pullRequests(from repository: Repository) -> Observable<(APIRequestResult, [PullRequest])> {
        if let error = mockedError {
            return error == .mockedNetworkError ? Observable.error(error) :  Observable.just((APIRequestResult.invalidJson,[PullRequest]()))
        }
        else {
            var pullRequests = [PullRequest]()
            for _ in 1...10 {
                pullRequests.append(PullRequest())
            }
            return Observable.just((APIRequestResult.success,pullRequests))
        }
    }
    
}

class RepositoryDetailInteractorSpec: QuickSpec {
    
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
                   interactor.loadPullRequests(ofRepository: Repository())
                   expect(interactor.fetchedPullRequests.value.0) == APIRequestResult.success
                   expect(interactor.fetchedPullRequests.value.1.count) == 10
                }
                
                it("holds an error after a network failure") {
                    mockStore.mockedError = .mockedNetworkError
                    interactor.loadPullRequests(ofRepository: Repository())
                    expect(interactor.fetchedPullRequests.value.0) == APIRequestResult.networkError
                    expect(interactor.fetchedPullRequests.value.1).to(beEmpty())
                }
                
                it("holds an error after others type of failure") {
                    mockStore.mockedError = .mockedInvalidJson
                    interactor.loadPullRequests(ofRepository: Repository())
                    expect(interactor.fetchedPullRequests.value.0) == APIRequestResult.invalidJson
                    expect(interactor.fetchedPullRequests.value.1).to(beEmpty())
                }
                
            })
            
        }
        
    }
}
