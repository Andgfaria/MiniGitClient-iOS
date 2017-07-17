//
//  RepositoryDetailPresenter.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 15/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit
import RxSwift

protocol RepositoryDetailInteractorProtocol : class {
    var pullRequestsStore : PullRequestsStore { get set }
    var fetchedPullRequests : Variable<(APIRequestResult,[PullRequest])> { get set }
    func loadPullRequests(ofRepository repository : Repository)
}

class RepositoryDetailPresenter : NSObject {
    
    fileprivate let repository : Repository
    
    weak var interactor : RepositoryDetailInteractorProtocol?
    
    required init(repository : Repository) {
        self.repository = repository
    }
    
}

extension RepositoryDetailPresenter : RepositoryDetailPresenterProtocol {
    
    func configureHeader(_ header: RepositoryDetailHeaderView) {
        RepositoryDetailHeaderViewModel.configureHeader(header, withRepository: repository)
    }
    
}
