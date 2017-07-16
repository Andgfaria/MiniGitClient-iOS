//
//  PullRequestTableViewCell.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 16/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit

class PullRequestTableViewCell: UITableViewCell {
    
    let titleLabel = UILabel(frame: CGRect.zero)
    
    let bodyLabel = UILabel(frame: CGRect.zero)
    
    let avatarImageView = UIImageView(frame: CGRect.zero)
    
    let authorLabel = UILabel(frame: CGRect.zero)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
}

extension PullRequestTableViewCell : ViewCodable {
    
    fileprivate func setup() {
        addViewsToHierarchy([titleLabel,bodyLabel,avatarImageView,authorLabel])
        setupConstraints()
        setupStyles()
    }
    
    func setupConstraints() {
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: avatarImageView.leadingAnchor, constant: -16).isActive = true
        
        bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6).isActive = true
        bodyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        bodyLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        bodyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        avatarImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 6).isActive = true
        avatarImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -18).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        authorLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 3).isActive = true
        authorLabel.widthAnchor.constraint(equalTo: avatarImageView.widthAnchor).isActive = true
        authorLabel.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor).isActive = true
        authorLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
    
    func setupStyles() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        
        bodyLabel.font = UIFont.systemFont(ofSize: 14)
        bodyLabel.numberOfLines = 0
        
        avatarImageView.layer.cornerRadius = 22
        avatarImageView.layer.masksToBounds = true
        
        authorLabel.textAlignment = .center
        authorLabel.font = UIFont.systemFont(ofSize: 7)
        authorLabel.textColor = .lightGray
        authorLabel.numberOfLines = 0
    }
    
}
