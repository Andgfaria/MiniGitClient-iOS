//
//  PullRequestTableViewCell.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 16/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit

class PullRequestTableViewCell: UITableViewCell {
    
    fileprivate let wrapperView = UIView(frame: CGRect.zero)
    
    let titleLabel = UILabel(frame: CGRect.zero)
    
    let bodyTextView = UITextView(frame: CGRect.zero)
    
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
        addViewsToHierarchy([wrapperView])
        setupConstraints()
        setupStyles()
    }
    
    func setupConstraints() {
        
        wrapperView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        wrapperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        wrapperView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        wrapperView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
        
        let heightConstraint = wrapperView.heightAnchor.constraint(greaterThanOrEqualToConstant: 72)
        heightConstraint.priority = 500
        heightConstraint.isActive = true
        
        let subviews = [titleLabel,bodyTextView,avatarImageView,authorLabel]
        for view in subviews {
            wrapperView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        titleLabel.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 6).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: avatarImageView.leadingAnchor, constant: -16).isActive = true
        
        bodyTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6).isActive = true
        bodyTextView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 11).isActive = true
        bodyTextView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        bodyTextView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor).isActive = true
        
        avatarImageView.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 6).isActive = true
        avatarImageView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -18).isActive = true
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
        
        bodyTextView.font = UIFont.systemFont(ofSize: 14)
        bodyTextView.isUserInteractionEnabled = false
        bodyTextView.isScrollEnabled = false
        bodyTextView.textContainerInset = UIEdgeInsets.zero
        
        avatarImageView.layer.cornerRadius = 22
        avatarImageView.layer.masksToBounds = true
        
        authorLabel.textAlignment = .center
        authorLabel.font = UIFont.systemFont(ofSize: 7)
        authorLabel.textColor = .lightGray
        authorLabel.numberOfLines = 0
    }
    
}
