//
//  RepositoriesStore.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 22/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
import RxSwift

@testable import MiniGitClient

class MainRepositoriesStoreSpec: QuickSpec {
    
    private var disposeBag = DisposeBag()
    
    private var repositories : [Repository]?
    
    override func spec() {
        
        describe("The Repositories Store") { 
            
            context("calls the GitHub API", {
                
                beforeEach {
                    self.repositories = nil
                }
                
                it("and receives an Swift repositories list for a given page") {
                    
                    MainRepositoriesStore.shared.swiftRepositories(forPage: 1)
                        .subscribe(
                            onNext: { [weak self] requestResult, repositories in
                                if requestResult != .success {
                                    fail()
                                }
                                else {
                                    self?.repositories = repositories
                                }
                            },
                            onError: { _ in
                                fail()
                            })
                        .addDisposableTo(self.disposeBag)
                    
                    expect(self.repositories).toEventuallyNot(beNil(), timeout: 30.0, pollInterval: 10.0)
                    
                }
                
            })
            
        }
        
    }
    
}
