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

protocol RepositoriesStore {
    func swiftRepositories(forPage page : Int) -> Observable<[Repository]>
}

struct MainRepositoriesStore : RepositoriesStore {

    static let shared = MainRepositoriesStore()
    
    private var config : APIConfig = MainAPIConfig.shared
    
    private init() { }
    
    func swiftRepositories(forPage page: Int) -> Observable<[Repository]> {
        if let searchEndpoint = config.urlString(with: .search) {
            let parameters : DataDict = ["q" : "language:Swift", "sort" : "stars", "page" : page]
            return json(.get, searchEndpoint, parameters: parameters, encoding: URLEncoding.queryString)
                   .map { json in
                        if let jsonData = json as? DataDict, let repositoriesList = jsonData["items"] as? [DataDict] {
                            return repositoriesList.flatMap { Repository.init(json: $0) }
                        }
                        else {
                            return [Repository]()
                        }
                   }
        }
        return Observable.just([])
    }
    
}
