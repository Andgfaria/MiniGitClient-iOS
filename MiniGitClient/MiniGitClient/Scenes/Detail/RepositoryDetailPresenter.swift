//
//  RepositoryDetailPresenter.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 15/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit
import RxSwift

protocol RepositoryDetailInteractorType : class {
    var fetchedPullRequests : Variable<(APIRequestResult,[PullRequest])> { get set }
    func loadPullRequests(ofRepository repository : Repository)
}

protocol RepositoryDetailRouterType : class {
    func openPullRequest(_ sender : RepositoryDetailPresenter, _ pullRequest : PullRequest)
}


class RepositoryDetailPresenter : NSObject {
    
    weak var viewController: RepositoryDetailViewController? {
        didSet {
            bind()
        }
    }
    
    fileprivate let repository : Repository
    
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
        if let interactor = interactor, let viewController = viewController {
            interactor.fetchedPullRequests
                      .asObservable()
                      .skip(1)
                      .subscribe(onNext: { _, pullRequests in
                            if pullRequests.count > 0 {
                                viewController.headerView.currentState.value = .loaded
                            }
                            else {
                                viewController.headerView.currentState.value = .showingRetryOption
                            }
                      })
                      .addDisposableTo(disposeBag)
        }
    }
    
}

extension RepositoryDetailPresenter : RepositoryDetailPresenterType {
    
    func configureHeader(_ header: RepositoryDetailHeaderView) {
        RepositoryDetailHeaderViewModel.configureHeader(header, withRepository: repository)
    }
    
    func registerTableView(_ tableView: UITableView) {
        tableView.register(PullRequestTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(PullRequestTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func loadPullRequests() {
        if let interactor = interactor {
            interactor.loadPullRequests(ofRepository: repository)
        }
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
