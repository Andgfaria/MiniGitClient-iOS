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
    func openPullRequest(_ sender : RepositoryDetailPresenter, _ pullRequest : PullRequest)
}


class RepositoryDetailPresenter : NSObject {
    
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

extension RepositoryDetailPresenter : RepositoryDetailPresenterType {
    
    func registerTableView(_ tableView: UITableView) {
        tableView.register(PullRequestTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(PullRequestTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension RepositoryDetailPresenter : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.fetchedPullRequests.value.1.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(PullRequestTableViewCell.self), for: indexPath)
        if let cell = cell as? PullRequestTableViewCell, let pullRequests = interactor?.fetchedPullRequests.value.1 {
            PullRequestCellViewModel.configure(cell, withPullRequest: pullRequests[indexPath.row])
        }
        return cell
    }
    
}

extension RepositoryDetailPresenter : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let pullRequests = interactor?.fetchedPullRequests.value.1 {
            router?.openPullRequest(self, pullRequests[indexPath.row])
        }
    }
    
}
