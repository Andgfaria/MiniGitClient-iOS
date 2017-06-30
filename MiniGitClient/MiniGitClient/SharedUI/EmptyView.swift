//
//  EmptyView.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 25/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum EmptyViewState {
    case loading, showingError
}

class EmptyView: UIView {
    
    var currentState = Variable(EmptyViewState.loading)
    
    var message = "" {
        didSet {
            messageLabel.text = message
        }
    }
    
    var actionTitle = "" {
        didSet {
            actionButton.setTitle(actionTitle, for: .normal)
        }
    }

    var actionBlock : ((Void) -> (Void))?
    
    fileprivate var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    fileprivate var messageLabel = UILabel(frame: CGRect.zero)
    
    fileprivate var actionButton = UIButton(frame: CGRect.zero)
    
    fileprivate var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    

}

extension EmptyView : ViewCodable {
    
    fileprivate func setup() {
        addViewsToHierarchy([activityIndicator,messageLabel,actionButton])
        setupConstraints()
        setupStyles()
        bindComponents()
    }
    
    func setupConstraints() {
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        messageLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: -36)
        messageLabel.heightAnchor.constraint(equalToConstant: 36)
        messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        actionButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        actionButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -44).isActive = true
        actionButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 12).isActive = true
    }
    
    func setupStyles() {
        activityIndicator.hidesWhenStopped = true
        
        messageLabel.font = UIFont.systemFont(ofSize: 24)
        messageLabel.textAlignment = .center
        messageLabel.textColor = .lightGray
        
        actionButton.backgroundColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        actionButton.layer.cornerRadius = 10.0
        actionButton.setTitleColor(.white, for: .normal)
    }
    
    func bindComponents() {
        actionButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.currentState.value = .loading
                self?.actionBlock?()
            })
            .addDisposableTo(disposeBag)
        
        currentState.asObservable()
            .map { $0 == .loading }
            .subscribe(onNext: { [weak self] in
                $0 ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            })
            .addDisposableTo(disposeBag)
        
        currentState.asObservable().map { $0 == .loading }.bind(to: messageLabel.rx.isHidden).addDisposableTo(disposeBag)
        currentState.asObservable().map { $0 == .loading }.bind(to: actionButton.rx.isHidden).addDisposableTo(disposeBag)
    }
    
}
