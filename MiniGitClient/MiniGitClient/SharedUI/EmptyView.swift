/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

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
        setup(withViews: [activityIndicator,messageLabel,actionButton])
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setup(withViews: [activityIndicator,messageLabel,actionButton])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup(withViews: [activityIndicator,messageLabel,actionButton])
    }
    

}

extension EmptyView : ViewCodable {
    
    func setupConstraints() {
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        messageLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75).isActive = true
        messageLabel.heightAnchor.constraint(equalToConstant: 48).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        actionButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        actionButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -44).isActive = true
    }
    
    func setupStyles() {
        activityIndicator.hidesWhenStopped = true
        
        messageLabel.font = UIFont.systemFont(ofSize: 20)
        messageLabel.minimumScaleFactor = CGFloat(0.5)
        messageLabel.textAlignment = .center
        messageLabel.textColor = .lightGray
        messageLabel.numberOfLines = 2
        
        actionButton.backgroundColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        actionButton.layer.cornerRadius = 10.0
        actionButton.setTitleColor(.white, for: .normal)
    }
    
    func bindComponents() {
        actionButton.rx
                    .tap
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
        currentState.asObservable()
                    .map { $0 == .loading }
                    .bind(to: messageLabel.rx.isHidden)
                    .addDisposableTo(disposeBag)
        currentState.asObservable()
                    .map { $0 == .loading }
                    .bind(to: actionButton.rx.isHidden)
                    .addDisposableTo(disposeBag)
    }
    
}
