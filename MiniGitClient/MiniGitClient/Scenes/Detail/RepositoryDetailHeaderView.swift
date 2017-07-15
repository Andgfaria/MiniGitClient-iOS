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

    let titleLabel = UILabel(frame: CGRect.zero)
    
    let bodyLabel = UILabel(frame: CGRect.zero)
    
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

    override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.size.width, height: titleLabel.intrinsicContentSize.height + bodyLabel.intrinsicContentSize.height + 24)
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
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 12).isActive = true
        
        stackView.addArrangedSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16).isActive = true

        stackView.addArrangedSubview(bodyLabel)
        bodyLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16).isActive = true
        bodyLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16).isActive = true
        bodyLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
    }
    
    func setupStyles() {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 18.0
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.numberOfLines = 0
        
        bodyLabel.font = UIFont.systemFont(ofSize: 18)
        bodyLabel.numberOfLines = 0
    }
    
}
