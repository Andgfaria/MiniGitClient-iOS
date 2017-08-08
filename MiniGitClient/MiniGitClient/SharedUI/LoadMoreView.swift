/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import UIKit
import RxSwift
import RxCocoa

enum LoadMoreViewState {
    case normal, loading
}

class LoadMoreView: UIView {

    var currentState = Variable(LoadMoreViewState.normal)
    
    var loadTitle = "" {
        didSet {
            actionButton.setTitle(loadTitle, for: .normal)
        }
    }
    
    var loadingBlock : ((Void) -> Void)?
    
    fileprivate var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    fileprivate var actionButton = UIButton(frame: CGRect.zero)
        
    fileprivate let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(withViews: [activityIndicator,actionButton])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup(withViews: [activityIndicator,actionButton])
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setup(withViews: [activityIndicator,actionButton])
    }
    
}

extension LoadMoreView : ViewCodable {
    
    func setupConstraints() {
        activityIndicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        actionButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75).isActive = true
        actionButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        actionButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
    }
    
    func setupStyles() {
        activityIndicator.hidesWhenStopped = true
        
        actionButton.backgroundColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        actionButton.layer.cornerRadius = 10.0
        actionButton.setTitleColor(.white, for: .normal)
    }
    
    func bindComponents() {
        actionButton.rx
                    .tap
                    .subscribe(onNext: { [weak self] in
                        self?.currentState.value = .loading
                    })
                    .addDisposableTo(disposeBag)
        currentState.asObservable()
                    .subscribe(onNext: { [weak self] in
                        if $0 == .loading {
                            self?.loadingBlock?()
                            self?.activityIndicator.startAnimating()
                        }
                        else {
                            self?.activityIndicator.stopAnimating()
                        }
                    })
                    .addDisposableTo(disposeBag)
        currentState.asObservable()
                    .map { $0 == .loading }
                    .bind(to: actionButton.rx.isHidden)
                    .addDisposableTo(disposeBag)
    }
    
    func setupAccessibilityIdentifiers() {
        activityIndicator.accessibilityIdentifier = "LoadMoreViewActivityIndicator"
        actionButton.accessibilityIdentifier = "LoadMoreViewButton"
    }
    
}
