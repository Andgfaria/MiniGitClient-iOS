//
//  RepositoryDetailPresenter.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 15/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit

class RepositoryDetailPresenter : NSObject {
    
    fileprivate let repository : Repository
    
    required init(repository : Repository) {
        self.repository = repository
    }
    
}

extension RepositoryDetailPresenter : RepositoryDetailPresenterProtocol {
    
    func configureHeader(_ header: RepositoryDetailHeaderView) {
        RepositoryDetailHeaderViewModel.configureHeader(header, withRepository: repository)
    }
    
}
