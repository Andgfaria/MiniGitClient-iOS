//
//  LoadMoreView.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 05/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum LoadMoreViewState {
    case normal, loading
}

class LoadMoreView: UIView {

    var currentState = Variable(LoadMoreViewState.normal)
    
    var actionTitle = "" {
        didSet {
            actionButton.setTitle(actionTitle, for: .normal)
        }
    }
    
    var loadingBlock : ((Void) -> Void)?
    
    fileprivate var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    fileprivate var actionButton = UIButton(frame: CGRect.zero)
    
    fileprivate var topSeparator = UIView(frame: CGRect.zero)
    
    fileprivate let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
}

extension LoadMoreView : ViewCodable {
    
    fileprivate func setup() {
        addViewsToHierarchy([activityIndicator,actionButton,topSeparator])
        setupConstraints()
        setupStyles()
        bindComponents()
    }
    
    func setupConstraints() {
        activityIndicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        actionButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75).isActive = true
        actionButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        actionButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        
        topSeparator.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -16).isActive = true
        topSeparator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        topSeparator.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        topSeparator.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    
    func setupStyles() {
        activityIndicator.hidesWhenStopped = true
        
        actionButton.backgroundColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        actionButton.layer.cornerRadius = 10.0
        actionButton.setTitleColor(.white, for: .normal)
        
        topSeparator.backgroundColor = UIColor(white: 0.878, alpha: 1)
    }
    
    func bindComponents() {
        actionButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.currentState.value = .loading
        }).addDisposableTo(disposeBag)
        currentState.asObservable().subscribe(onNext: { [weak self] in
            if $0 == .loading {
                self?.loadingBlock?()
                self?.activityIndicator.startAnimating()
            }
            else {
                self?.activityIndicator.stopAnimating()
            }
        }).addDisposableTo(disposeBag)
        currentState.asObservable().map { $0 == .loading }.bind(to: actionButton.rx.isHidden).addDisposableTo(disposeBag)
    }
    
}
