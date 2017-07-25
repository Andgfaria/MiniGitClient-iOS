//
//  PullRequestsStoreSpec.swift
//  MiniGitClient
//
//  Created by Andre Faria on 11/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
import RxSwift
@testable import MiniGitClient

class PullRequestsStoreSpec: QuickSpec {
    
    private let disposeBag = DisposeBag()
    
    var pullRequests : [PullRequest]?
    
    override func spec() {
        
        describe("The PullRequestsStore") { 
            
            context("calls the GitHub API", { 
                
                beforeEach {
                    self.pullRequests = nil
                }
                
                it("and receives the pull requests from a given repository") {
                    var testRepository = Repository()
                    testRepository.name = "Alamofire"
                    testRepository.owner = RepositoryOwner()
                    testRepository.owner?.name = "Alamofire"
                    
                    PullRequestsStore.shared.pullRequests(from: testRepository)
                                                .subscribe(onNext: { [weak self] result, fetchedPullRequests in
                                                    if result != .success {
                                                        fail()
                                                    }
                                                    else {
                                                        self?.pullRequests = fetchedPullRequests
                                                    }
                                                },
                                                onError: { _ in
                                                    fail()
                                                })
                                                .addDisposableTo(self.disposeBag)
                    
                    expect(self.pullRequests).toNotEventually(beNil(), timeout: 30.0, pollInterval: 10.0)
                }
                
            })
            
        }
        
    }
    
}