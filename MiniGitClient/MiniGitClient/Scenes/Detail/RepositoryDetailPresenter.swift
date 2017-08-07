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
    func pullRequests(ofRepository repository : Repository) -> Observable<[PullRequest]>
}

protocol RepositoryDetailRouterType : class {
    func onPullRequestSelection(_ pullRequest : PullRequest)
}


class RepositoryDetailPresenter : RepositoryDetailPresenterType {
    
    var currentState = Variable(RepositoryDetailState.loading)
    
    var repository : Variable<Repository>
    
    var pullRequests = Variable([PullRequest]())
    
    weak var interactor : RepositoryDetailInteractorType? {
        didSet {
            bind()
        }
    }
    
    weak var router : RepositoryDetailRouterType?
    
    var shareItems : [Any] {
        guard let url = repository.value.url else { return [repository.value.name] }
        return [repository.value.name,url]
    }
    
    fileprivate let disposeBag = DisposeBag()
    
    required init(repository : Repository) {
        self.repository = Variable(repository)
    }
    
}

extension RepositoryDetailPresenter {
    
    fileprivate func bind() {
        currentState.asObservable()
                    .subscribe(onNext: { [weak self] in
                        if $0 == .loading {
                            self?.fetchPullRequests()
                        }
                    })
                    .addDisposableTo(disposeBag)
    }

    private func fetchPullRequests() {
        interactor?.pullRequests(ofRepository: repository.value)
            .subscribe(onNext: { [weak self] fetchedPullRequests in
                if fetchedPullRequests.count > 0 {
                    self?.currentState.value = .showingPullRequests
                    self?.pullRequests.value = fetchedPullRequests
                }
                else {
                    self?.currentState.value = .onError
                }
                },
                       onError: { [weak self] _ in
                        self?.currentState.value = .onError
            })
            .addDisposableTo(disposeBag)
    }
    
}


extension RepositoryDetailPresenter : TableViewSelectionHandler {
    
    func onSelection(ofIndex index: Int, atSection section: Int, withModel model: Any?) {
        if let pullRequest = model as? PullRequest {
            router?.onPullRequestSelection(pullRequest)
        }
    }
    
}
