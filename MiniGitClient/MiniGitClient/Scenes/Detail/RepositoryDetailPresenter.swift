//
//  RepositoryDetailPresenter.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 15/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit
import RxSwift

enum RepositoryDetailState {
    case loading, showingPullRequests, onError
}

protocol RepositoryDetailInteractorType : class {
    var fetchedPullRequests : Variable<(APIRequestResult,[PullRequest])> { get set }
    func loadPullRequests(ofRepository repository : Repository)
}

protocol RepositoryDetailRouterType : class {
    func onPullRequestSelection(_ pullRequest : PullRequest)
}


class RepositoryDetailPresenter : RepositoryDetailPresenterType {
    
    var currentState = Variable(RepositoryDetailState.loading)
    
    weak var viewController: RepositoryDetailViewController? {
        didSet {
            bind()
        }
    }
    
    var repository : Repository
    
    weak var interactor : RepositoryDetailInteractorType? {
        didSet {
            bind()
        }
    }
    
    weak var router : RepositoryDetailRouterType?
    
    var shareItems : [Any] {
        guard let url = repository.url else { return [repository.name] }
        return [repository.name,url]
    }
    
    fileprivate let disposeBag = DisposeBag()
    
    required init(repository : Repository) {
        self.repository = repository
    }
    
}

extension RepositoryDetailPresenter {
    
    fileprivate func bind() {
        if let interactor = interactor {
            interactor.fetchedPullRequests
                      .asObservable()
                      .skip(1)
                      .subscribe(onNext: { [weak self] _, pullRequests in
                            if pullRequests.count > 0 {
                                self?.currentState.value = .showingPullRequests
                                self?.viewController?.show(pullRequests: pullRequests)
                            }
                            else {
                                self?.currentState.value = .onError
                            }
                      })
                      .addDisposableTo(disposeBag)
            currentState.asObservable()
                        .subscribe(onNext: { [weak self] in
                            if $0 == .loading {
                                if let repository = self?.repository {
                                    interactor.loadPullRequests(ofRepository: repository)
                                }
                            }
                        })
                        .addDisposableTo(disposeBag)
        }
    }
    
}

extension RepositoryDetailPresenter : TableViewSelectionHandler {
    
    func onSelection(ofIndex index: Int, atSection section: Int, withModel model: Any?) {
        if let pullRequest = model as? PullRequest {
            router?.onPullRequestSelection(pullRequest)
        }
    }
    
}
