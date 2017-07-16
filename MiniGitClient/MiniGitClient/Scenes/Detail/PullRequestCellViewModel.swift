//
//  PullRequestCellViewModel.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 16/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit
import Kingfisher

struct PullRequestCellViewModel {
    
    private init() { }

    static func configure(_ cell : PullRequestTableViewCell, withPullRequest pullRequest : PullRequest) {
        cell.titleLabel.text = pullRequest.title
        cell.bodyLabel.text = pullRequest.body
        cell.authorLabel.text = pullRequest.user?.name
        if let avatarURL = pullRequest.user?.avatarURL {
            cell.avatarImageView.kf.setImage(with: avatarURL)
        }
    }
    
}
