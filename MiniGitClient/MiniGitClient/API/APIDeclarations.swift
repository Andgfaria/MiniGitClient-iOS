//
//  APIDeclarations.swift
//  MiniGitClient
//
//  Created by Andre Faria on 08/08/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import RxSwift

typealias DataDict = [String : Any]

enum RequestResult<T> {
    case success(T)
    case failure(Error)
}

enum APIRequestError : Error {
    case networkError, invalidJson, invalidEndpoint
}

protocol APIConfigType {
    func urlString(with endPoint : Endpoint) -> String?
}

protocol RepositoriesStoreType {
    func swiftRepositories(forPage page : Int) -> Observable<RequestResult<[Repository]>>
}


protocol PullRequestsStoreType {
    func pullRequests(from repository : Repository) -> Observable<RequestResult<[PullRequest]>>
}
