/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

struct PullRequestsStore {
    
    static let shared = PullRequestsStore()
    
    fileprivate let config = APIConfig.shared
    
    private init() { }
    
}

extension PullRequestsStore : PullRequestsStoreType {
    
    func pullRequests(from repository : Repository) -> Observable<RequestResult<[PullRequest]>> {
        if let rawPullRequestsEndpoints = config.urlString(with: .pullRequests), let user = repository.user {
            if let pullRequestEndpoint = String(format: rawPullRequestsEndpoints, user.name, repository.name).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                return json(.get, pullRequestEndpoint)
                       .map { json in
                            guard let jsonData = json as? [DataDict] else { return RequestResult.failure(APIRequestError.invalidJson) }
                            return RequestResult.success(jsonData.flatMap { PullRequest.init(json: $0) })
                        }
            }
        }
        return Observable.error(APIRequestError.invalidEndpoint)
    }
    
}
