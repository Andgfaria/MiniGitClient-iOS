//
//  RepositoryListTableViewCell.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 30/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit
import Rswift

class RepositoryListTableViewCell: UITableViewCell {
    
    var titleLabel = UILabel(frame: CGRect.zero)

    var infoLabel = UILabel(frame: CGRect.zero)
    
    fileprivate var starImageView = UIImageView(image: nil)
    
    var starsCountLabel = UILabel(frame: CGRect.zero)
    
    fileprivate var forkImageView = UIImageView(image: nil)
    
    var forksCountLabel = UILabel(frame: CGRect.zero)
    
    var avatarImageView = UIImageView(frame: CGRect.zero)
    
    var repositoryOwnerLabel = UILabel(frame: CGRect.zero)
    
    init() {
        super.init(style: .default, reuseIdentifier: nil)
        setup(withViews: [titleLabel,infoLabel,starImageView,starsCountLabel,forkImageView,forksCountLabel,avatarImageView,repositoryOwnerLabel])
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup(withViews: [titleLabel,infoLabel,starImageView,starsCountLabel,forkImageView,forksCountLabel,avatarImageView,repositoryOwnerLabel])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup(withViews: [titleLabel,infoLabel,starImageView,starsCountLabel,forkImageView,forksCountLabel,avatarImageView,repositoryOwnerLabel])
    }

}

extension RepositoryListTableViewCell : ViewCodable {
    
    func setupConstraints() {
        titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 18).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: avatarImageView.leadingAnchor, constant: -12).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 6).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: infoLabel.topAnchor, constant: -3).isActive = true
        
        infoLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: starImageView.topAnchor, constant: -6).isActive = true
        
        starImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        starImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        starImageView.leadingAnchor.constraint(equalTo: infoLabel.leadingAnchor).isActive = true
        starImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -6).isActive = true
        
        starsCountLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 3).isActive = true
        starsCountLabel.trailingAnchor.constraint(equalTo: forkImageView.leadingAnchor, constant: -6).isActive = true
        starsCountLabel.heightAnchor.constraint(equalTo: starImageView.heightAnchor).isActive = true
        starsCountLabel.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor).isActive = true
        
        forkImageView.heightAnchor.constraint(equalTo: starImageView.heightAnchor).isActive = true
        forkImageView.widthAnchor.constraint(equalTo: starImageView.widthAnchor).isActive = true
        forkImageView.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor).isActive = true
        
        forksCountLabel.leadingAnchor.constraint(equalTo: forkImageView.trailingAnchor, constant: 0).isActive = true
        forksCountLabel.widthAnchor.constraint(equalTo: starsCountLabel.widthAnchor).isActive = true
        forksCountLabel.heightAnchor.constraint(equalTo: forkImageView.heightAnchor).isActive = true
        forksCountLabel.centerYAnchor.constraint(equalTo: forkImageView.centerYAnchor).isActive = true
        
        avatarImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 6).isActive = true
        avatarImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -18).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 56).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        repositoryOwnerLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 3).isActive = true
        repositoryOwnerLabel.widthAnchor.constraint(equalTo: avatarImageView.widthAnchor).isActive = true
        repositoryOwnerLabel.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor).isActive = true
        repositoryOwnerLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
    
    func setupStyles() {        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.numberOfLines = 0
        
        infoLabel.font = UIFont.systemFont(ofSize: 17)
        infoLabel.numberOfLines = 0
        
        starImageView.image = R.image.star()
        starImageView.tintColor = .lightGray
        
        starsCountLabel.font = UIFont.systemFont(ofSize: 15)
        starsCountLabel.textColor = .lightGray
        
        forkImageView.image = R.image.fork()
        forkImageView.tintColor = .lightGray
        
        forksCountLabel.font = starsCountLabel.font
        forksCountLabel.textColor = starsCountLabel.textColor
        
        avatarImageView.layer.cornerRadius = 28
        avatarImageView.layer.masksToBounds = true
        
        repositoryOwnerLabel.textAlignment = .center
        repositoryOwnerLabel.font = UIFont.systemFont(ofSize: 9)
        repositoryOwnerLabel.textColor = .lightGray
        repositoryOwnerLabel.numberOfLines = 0
    }
    
}
