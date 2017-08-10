/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import Foundation
import RxSwift

class RepositoryDetailInteractor {
    
    var store : PullRequestsStoreType = PullRequestsStore.shared
    
}

extension RepositoryDetailInteractor : RepositoryDetailInteractorType {
    
    func pullRequests(ofRepository repository : Repository) -> Observable<[PullRequest]> {
        return store.pullRequests(from: repository)
                    .flatMap { requestResult -> Observable<[PullRequest]> in
                        switch requestResult {
                        case .success(let pullRequests):
                            return Observable.just(pullRequests)
                        case .failure(let error):
                            return Observable.error(error)
                    }
            }
    }
  
}
