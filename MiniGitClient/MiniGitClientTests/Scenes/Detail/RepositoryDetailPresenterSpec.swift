/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

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
