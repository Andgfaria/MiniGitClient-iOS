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
