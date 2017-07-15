//
//  RepositoryDetailHeaderView.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 15/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit

class RepositoryDetailHeaderView: UIView {
    
    fileprivate let stackView = UIStackView()

    let nameLabel = UILabel(frame: CGRect.zero)
    
    let infoLabel = UILabel(frame: CGRect.zero)

    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
}

extension RepositoryDetailHeaderView {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.size.width, height: nameLabel.intrinsicContentSize.height + infoLabel.intrinsicContentSize.height + stackView.spacing + 24)
    }
    
    func adjustLayout(withWidth width : CGFloat) {
        nameLabel.preferredMaxLayoutWidth = width - 32
        infoLabel.preferredMaxLayoutWidth = nameLabel.preferredMaxLayoutWidth
    }
    
}

extension RepositoryDetailHeaderView : ViewCodable {
    
    fileprivate func setup() {
        addViewsToHierarchy([stackView])
        setupConstraints()
        setupStyles()
    }
    
    func setupConstraints() {
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        
        stackView.addArrangedSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16).isActive = true

        stackView.addArrangedSubview(infoLabel)
        infoLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
    }
    
    func setupStyles() {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 18.0
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 28)
        nameLabel.numberOfLines = 0
        
        infoLabel.font = UIFont.systemFont(ofSize: 18)
        infoLabel.numberOfLines = 0
    }
    
}
