/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import UIKit
import RxSwift

class RepositoryDetailPresenter : RepositoryDetailPresenterType {
    
    var currentState = Variable(RepositoryDetailState.loading)
    
    var repository : Variable<Repository>
    
    var pullRequests = Variable([PullRequest]())
    
    weak var interactor : RepositoryDetailInteractorType? {
        didSet {
            bind()
        }
    }
    
    weak var router : RepositoryDetailRouterType?
    
    var shareItems : [Any] {
        guard let url = repository.value.url else { return [repository.value.name] }
        return [repository.value.name,url]
    }
    
    fileprivate let disposeBag = DisposeBag()
    
    required init(repository : Repository) {
        self.repository = Variable(repository)
    }
    
}

extension RepositoryDetailPresenter {
    
    fileprivate func bind() {
        currentState.asObservable()
                    .subscribe(onNext: { [weak self] in
                        if $0 == .loading {
                            self?.fetchPullRequests()
                        }
                    })
                    .addDisposableTo(disposeBag)
    }

    private func fetchPullRequests() {
        interactor?.pullRequests(ofRepository: repository.value)
                   .subscribe(onNext: { [weak self] fetchedPullRequests in
                        if fetchedPullRequests.count > 0 {
                            self?.currentState.value = .showingPullRequests
                            self?.pullRequests.value = fetchedPullRequests
                        }
                        else {
                            self?.currentState.value = .onError
                        }
                    },
                    onError: { [weak self] _ in
                        self?.currentState.value = .onError
                    })
                    .addDisposableTo(disposeBag)
    }
    
}


extension RepositoryDetailPresenter : TableViewSelectionHandler {
    
    func onSelection(ofIndex index: Int, atSection section: Int, withModel model: Any?) {
        if let pullRequest = model as? PullRequest {
            router?.onPullRequestSelection(pullRequest)
        }
    }
    
}
