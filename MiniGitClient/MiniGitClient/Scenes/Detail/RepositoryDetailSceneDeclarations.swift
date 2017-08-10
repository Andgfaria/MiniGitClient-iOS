//
//  RepositoryDetailSceneDeclarations.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 07/08/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit
import RxSwift

protocol RepositoryDetailPresenterType : class {
    var currentState : Variable<RepositoryDetailState> { get set }
    var repository : Variable<Repository> { get }
    var pullRequests : Variable<[PullRequest]> { get }
    var shareItems : [Any] { get }
}

protocol RepositoryDetailTableViewModelType : class, TableViewModel {
    var selectionHandler : TableViewSelectionHandler? { get set }
    func update(withPullRequests pullRequests : [PullRequest])
}

enum RepositoryDetailState {
    case loading, showingPullRequests, onError
}

protocol RepositoryDetailInteractorType : class {
    func pullRequests(ofRepository repository : Repository) -> Observable<[PullRequest]>
}

protocol RepositoryDetailRouterType : class {
    func onPullRequestSelection(_ pullRequest : PullRequest)
}
