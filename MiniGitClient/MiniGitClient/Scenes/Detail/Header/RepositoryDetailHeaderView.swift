/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

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
    
    var currentState = Variable(RepositoryDetailHeaderState.loading)
    
    fileprivate let disposeBag = DisposeBag()
    
    init() {
        super.init(frame: CGRect.zero)
        setup(withViews: [stackView])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(withViews: [stackView])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup(withViews: [stackView])
    }
    
}

extension RepositoryDetailHeaderView {
    
    override var intrinsicContentSize: CGSize {
        let offSet : CGFloat = currentState.value == .loaded ? 48 : 96
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
        stackView.removeArrangedSubview(loadView)
        loadView.removeConstraints(loadView.constraints)
        loadView.removeFromSuperview()
        layoutIfNeeded()
    }
    
}

extension RepositoryDetailHeaderView : ViewCodable {
    
    func setupConstraints() {
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
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
