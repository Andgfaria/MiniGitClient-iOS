//
//  RepositoryListCellViewModel.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 30/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

struct RepositoryListCellViewModel {
   
    static func configure(_ cell : RepositoryListTableViewCell, with repository : Repository) {
        cell.titleLabel.text = repository.name
        cell.infoLabel.text = repository.info
        cell.starsCountLabel.text = "\(repository.starsCount)"
        cell.forksCountLabel.text = "\(repository.forksCount)"
        cell.repositoryOwnerLabel.text = "\(repository.owner?.name ?? "")"
        if let avatarURL = repository.owner?.avatarURL {
            cell.avatarImageView.kf.setImage(with: avatarURL)
        }
    }
    
    private init() { }
    
}
