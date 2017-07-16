//
//  RepositoryDetailHeaderView.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 15/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit
import RxSwift

enum RepositoryDetailHeaderState {
    case loading, loaded, showingRetryOption
}

class RepositoryDetailHeaderView: UIView {
    
    fileprivate let stackView = UIStackView()

    let nameLabel = UILabel(frame: CGRect.zero)
    
    let infoLabel = UILabel(frame: CGRect.zero)

    fileprivate let loadView = LoadMoreView()
    
    var currentState = Variable(RepositoryDetailHeaderState.loaded)
    
    var retryLoadBlock : ((Void) -> Void)? {
        didSet {
            loadView.loadingBlock = retryLoadBlock
        }
    }
    
    fileprivate let disposeBag = DisposeBag()
    
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
        let offSet : CGFloat = currentState.value == .loaded ? 24 : 96
        return CGSize(width: bounds.size.width, height: nameLabel.intrinsicContentSize.height + infoLabel.intrinsicContentSize.height + stackView.spacing + offSet)
    }
    
    func adjustLayout(withWidth width : CGFloat) {
        nameLabel.preferredMaxLayoutWidth = width - 32
        infoLabel.preferredMaxLayoutWidth = nameLabel.preferredMaxLayoutWidth
    }
    
}

extension RepositoryDetailHeaderView {
    
    fileprivate func addLoadView() {
        stackView.addArrangedSubview(loadView)
        loadView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        loadView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        loadView.heightAnchor.constraint(equalToConstant: 72).isActive = true
        loadView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
    }
    
    fileprivate func removeLoadView() {
        loadView.isHidden = true
        loadView.removeConstraints(loadView.constraints)
        infoLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        layoutIfNeeded()
    }
    
}

extension RepositoryDetailHeaderView : ViewCodable {
    
    fileprivate func setup() {
        addViewsToHierarchy([stackView])
        setupConstraints()
        setupStyles()
        bindComponents()
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
        
        addLoadView()
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
        
        loadView.loadTitle = R.string.detail.retryTitle()
    }
    
    func bindComponents() {
        loadView.loadingBlock = retryLoadBlock
        currentState.asObservable()
                    .map { $0 == .loading ? LoadMoreViewState.loading : LoadMoreViewState.normal }
                    .bind(to: loadView.currentState)
                    .addDisposableTo(disposeBag)
        currentState.asObservable()
                    .subscribe(onNext: { [weak self] in
                        if $0 == .loaded {
                            self?.removeLoadView()
                        }
                        else {
                            self?.addLoadView()
                        }
                    })
                    .addDisposableTo(disposeBag)
    }
    
}
