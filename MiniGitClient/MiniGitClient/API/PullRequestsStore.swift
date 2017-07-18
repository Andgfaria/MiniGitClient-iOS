//
//  PullRequestsStore.swift
//  MiniGitClient
//
//  Created by Andre Faria on 11/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

protocol PullRequestsStore {
    func pullRequests(from repository : Repository) -> Observable<(APIRequestResult,[PullRequest])>
}

struct MainPullRequestsStore {
    
    static let shared = MainPullRequestsStore()
    
    fileprivate let config = MainAPIConfig.shared
    
    private init() { }
    
}

extension MainPullRequestsStore : PullRequestsStore {
    
    func pullRequests(from repository : Repository) -> Observable<(APIRequestResult,[PullRequest])> {
        if let rawPullRequestsEndpoints = config.urlString(with: .pullRequests), let owner = repository.owner {
            if let pullRequestEndpoint = String(format: rawPullRequestsEndpoints, owner.name, repository.name).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                return json(.get, pullRequestEndpoint)
                       .map { json in
                            guard let jsonData = json as? [DataDict] else { return (APIRequestResult.invalidJson,[PullRequest]()) }
                            return (APIRequestResult.success, jsonData.flatMap { PullRequest.init(json: $0) })
                        }
            }
        }
        return Observable.just((APIRequestResult.invalidEndpoint,[PullRequest]()))
    }
    
}