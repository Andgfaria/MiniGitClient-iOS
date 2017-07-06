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

struct MockRepositoriesStore : RepositoriesStore {
    
    var shouldFail = false
    
    func swiftRepositories(forPage page: Int) -> Observable<(APIRequestResult,[Repository])> {
        if shouldFail {
            return Observable.just((APIRequestResult.networkError,[Repository]()))
        }
        else {
            var testRepository = Repository()
            testRepository.name = "Test"
            testRepository.info = "Description"
            return Observable.just((APIRequestResult.success,[testRepository]))
        }
    }
    
}

class RepositoryListInteractorSpec: QuickSpec {
    
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
                
                it("fetch repositories incrementing a page property") {
                    repositoryListInteractor.loadRepositories()
                    expect(repositoryListInteractor.fetchResults.value.0) == APIRequestResult.success
                    expect(repositoryListInteractor.fetchResults.value.1.count) == 1
                    
                    repositoryListInteractor.loadRepositories()
                    expect(repositoryListInteractor.fetchResults.value.0) == APIRequestResult.success
                    expect(repositoryListInteractor.fetchResults.value.1.count) == 2
                }
                
                it("keeps the repositories list safe after a request error") {
                    repositoryListInteractor.loadRepositories()
                    
                    mockRepositoryStore.shouldFail = true
                    repositoryListInteractor.repositoriesStore = mockRepositoryStore
                
                    repositoryListInteractor.loadRepositories()
                    
                    expect(repositoryListInteractor.fetchResults.value.0) == APIRequestResult.networkError
                    expect(repositoryListInteractor.fetchResults.value.1.count) == 1
                }
                
            })
            
        }
        
    }
    
}
