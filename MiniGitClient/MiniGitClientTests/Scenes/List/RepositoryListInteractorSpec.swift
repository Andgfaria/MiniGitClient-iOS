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

private struct MockRepositoriesStore : RepositoriesStoreType {
    
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
