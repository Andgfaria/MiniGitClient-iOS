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

struct RepositoriesStore : RepositoriesStoreType {

    static let shared = RepositoriesStore()
    
    private var config : APIConfigType = APIConfig.shared
    
    private init() { }
    
    func swiftRepositories(forPage page: Int) -> Observable<RequestResult<[Repository]>> {
        if let searchEndpoint = config.urlString(with: .search) {
            let parameters : DataDict = ["q" : "language:Swift", "sort" : "stars", "page" : page]
            return json(.get, searchEndpoint, parameters: parameters, encoding: URLEncoding.queryString)
                   .map { json in
                        if let jsonData = json as? DataDict, let repositoriesList = jsonData["items"] as? [DataDict] {
                            return RequestResult.success(repositoriesList.flatMap { Repository.init(json: $0) })
                        }
                        else {
                            return RequestResult.failure(APIRequestError.invalidJson)
                        }
                   }
        }
        return Observable.error(APIRequestError.invalidEndpoint)
    }
    
}
