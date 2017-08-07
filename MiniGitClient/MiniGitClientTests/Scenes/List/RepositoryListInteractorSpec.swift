//
//  RepositoryListInteractorSpec.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 24/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
import RxSwift
@testable import MiniGitClient

struct MockRepositoriesStore : RepositoriesStoreType {
    
    var shouldFail = false
    
    func swiftRepositories(forPage page: Int) -> Observable<RequestResult<[Repository]>> {
        if shouldFail {
            return Observable.error(APIRequestError.networkError)
        }
        return Observable.just(RequestResult.success([Repository()]))
    }
    
}

class RepositoryListInteractorSpec: QuickSpec {
    
    private let disposeBag = DisposeBag()
    
    override func spec() {
        
        describe("The Repository List Interactor") {
            
            var repositoryListInteractor = RepositoryListInteractor()
            
            var mockRepositoryStore = MockRepositoriesStore()
            
            beforeEach {
                repositoryListInteractor = RepositoryListInteractor()
                mockRepositoryStore = MockRepositoriesStore()
                repositoryListInteractor.repositoriesStore = mockRepositoryStore
            }
            
            context("can", {
                
                it("fetch repositories for a given page") {
                    var didReceiveRepositories = false
                    repositoryListInteractor.repositories(fromPage: 1)
                                            .subscribe(onNext: {
                                                didReceiveRepositories = $0.count > 0
                                            })
                                            .addDisposableTo(self.disposeBag)
                    expect(didReceiveRepositories).toEventually(beTrue())
                }
                
            })
            
        }
        
    }
    
}
