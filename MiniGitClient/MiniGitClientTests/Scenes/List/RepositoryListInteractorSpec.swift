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
    
    func swiftRepositories(forPage page: Int) -> Observable<(APIRequestResult,[Repository])> {
        var testRepository = Repository()
        testRepository.name = "Test"
        testRepository.info = "Description"
        return Observable.just((APIRequestResult.success,[testRepository]))
    }
    
}

class RepositoryListInteractorSpec: QuickSpec {
    
    override func spec() {
        
        describe("The Repository List Interactor") {
            
            var repositoryListInteractor : RepositoryListInteractor?
            
            beforeEach {
                repositoryListInteractor = nil
            }
            
            context("has", {
                
                it("a repositories variable") {
                    repositoryListInteractor = RepositoryListInteractor()
                    expect(repositoryListInteractor?.fetchResults.value.1).toNot(beNil())
                }
                
            })
            
            context("can", { 
                
                it("fetch repositories incrementing a page property") {
                    repositoryListInteractor = RepositoryListInteractor()
                    repositoryListInteractor?.repositoriesStore = MockRepositoriesStore()
                    
                    repositoryListInteractor?.loadRepositories()
                    expect(repositoryListInteractor?.fetchResults.value.1.count) == 1
                    
                    repositoryListInteractor?.loadRepositories()
                    expect(repositoryListInteractor?.fetchResults.value.1.count) == 2
                }
                
            })
            
        }
        
    }
    
}
