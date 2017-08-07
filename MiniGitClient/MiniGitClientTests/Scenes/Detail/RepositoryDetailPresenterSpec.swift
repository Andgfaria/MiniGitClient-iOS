//
//  RepositoryDetailPresenterSpec.swift
//  MiniGitClient
//
//  Created by Andre Faria on 24/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
import RxSwift

@testable import MiniGitClient

private class MockInteractor : RepositoryDetailInteractorType {
    
    var shouldFail = false
    
    func pullRequests(ofRepository repository: Repository) -> Observable<[PullRequest]> {
        if shouldFail {
            return Observable.error(APIRequestError.networkError)
        }
        var pullRequests = [PullRequest]()
        for _ in 1...10 {
            pullRequests.append(PullRequest())
        }
        return Observable.just(pullRequests)
    }

}

private class MockRouter : RepositoryDetailRouterType {
    
    var didCallRouterMethod = false
    
    func onPullRequestSelection(_ pullRequest: PullRequest) {
        didCallRouterMethod = true
    }
}

class RepositoryDetailPresenterSpec: QuickSpec {
    
    private let disposeBag = DisposeBag()
    
    override func spec() {
        
        describe("The RepositoryDetailPresenter") { 
            
            var testRepository = Repository()
            
            var presenter : RepositoryDetailPresenter?
            
            var mockInteractor = MockInteractor()
            
            var mockRouter = MockRouter()
                        
            beforeEach {
                testRepository = Repository()
                testRepository.name = "Name"
                testRepository.info = "Info"
                testRepository.url = URL(string: "http://www.pudim.com.br/")
                
                presenter = RepositoryDetailPresenter(repository: testRepository)
                mockInteractor = MockInteractor()
                mockRouter = MockRouter()
                presenter?.interactor = mockInteractor
                presenter?.router = mockRouter
            }
            
            context("has", { 
                
                it("a repository property") {
                    expect(presenter?.repository.value).toNot(beNil())
                }
                
                it("a pull requests property") {
                    expect(presenter?.pullRequests.value).toNot(beNil())
                }
                
            })
            
            context("when loading") {
                
                it("retrieves the pull requests from the interactor") {
                    presenter?.currentState.value = .loading
                    expect(presenter?.pullRequests.value.count) == 10
                }
                
            }
            
            context("after retrieving the pull requests from the interactor", {
                
                it("changes the current state to loaded when successfull") {
                    presenter?.currentState.value = .loading
                    expect(presenter?.currentState.value) == .showingPullRequests
                }
                
                it("changes the current state to showingRetryOption after a failure") {
                    mockInteractor.shouldFail = true
                    presenter?.currentState.value = .loading
                    expect(presenter?.currentState.value) == .onError
                }
                
            })
            
            context("passes", {
                
                it("the pull request to the router") {
                    presenter?.onSelection(ofIndex: 0, atSection: 0, withModel: PullRequest())
                    expect(mockRouter.didCallRouterMethod).to(beTrue())
                }
                
            })
            
            
            context("returns", {
                
                it("the repository name and url, if available") {
                    guard let items = presenter?.shareItems else { fail(); return }
                    expect(items.count) == 2
                    expect(items[0]).to(beAKindOf(String.self))
                    expect(items[1]).to(beAKindOf(URL.self))
                }
                
                it("the repository name if the url is unavailable") {
                    testRepository.url = nil
                    presenter = RepositoryDetailPresenter(repository: testRepository)
                    guard let items = presenter?.shareItems else { fail(); return }
                    expect(items.count) == 1
                    expect(items[0]).to(beAKindOf(String.self))
                }
                
            })
            
        }
        
    }
    
}
