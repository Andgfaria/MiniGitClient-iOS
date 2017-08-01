//
//  PullRequestsStoreType.swift
//  MiniGitClient
//
//  Created by Andre Faria on 11/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

protocol PullRequestsStoreType {
    func pullRequests(from repository : Repository) -> Observable<(APIRequestResult,[PullRequest])>
}

struct PullRequestsStore {
    
    static let shared = PullRequestsStore()
    
    fileprivate let config = APIConfig.shared
    
    private init() { }
    
}

extension PullRequestsStore : PullRequestsStoreType {
    
    func pullRequests(from repository : Repository) -> Observable<(APIRequestResult,[PullRequest])> {
        if let rawPullRequestsEndpoints = config.urlString(with: .pullRequests), let user = repository.user {
            if let pullRequestEndpoint = String(format: rawPullRequestsEndpoints, user.name, repository.name).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
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
