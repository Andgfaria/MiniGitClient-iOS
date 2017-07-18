//
//  RepositoryDetailHeaderViewModel.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 15/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit

struct RepositoryDetailHeaderViewModel {
    
    private init() { }
    
    static func configureHeader(_ header : RepositoryDetailHeaderView, withRepository repository : Repository) {
        header.nameLabel.text = repository.name
        header.infoLabel.text = repository.info
    }
    
}
