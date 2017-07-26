//
//  RepositoriesStore.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 20/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

protocol RepositoriesStoreType {
    func swiftRepositories(forPage page : Int) -> Observable<(APIRequestResult,[Repository])>
}

struct RepositoriesStore : RepositoriesStoreType {

    static let shared = RepositoriesStore()
    
    private var config : APIConfigType = APIConfig.shared
    
    private init() { }
    
    func swiftRepositories(forPage page: Int) -> Observable<(APIRequestResult,[Repository])> {
        if let searchEndpoint = config.urlString(with: .search) {
            let parameters : DataDict = ["q" : "language:Swift", "sort" : "stars", "page" : page]
            return json(.get, searchEndpoint, parameters: parameters, encoding: URLEncoding.queryString)
                   .map { json in
                        if let jsonData = json as? DataDict, let repositoriesList = jsonData["items"] as? [DataDict] {
                            return (APIRequestResult.success,repositoriesList.flatMap { Repository.init(json: $0) })
                        }
                        else {
                            return (APIRequestResult.invalidJson,[Repository]())
                        }
                   }
        }
        return Observable.just((APIRequestResult.invalidEndpoint,[Repository]()))
    }
    
}
