/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import Foundation
import RxSwift

class RepositoryListPresenter : NSObject {
    
    var currentState = Variable(RepositoryListState.loadingFirst)
    
    var repositories = Variable([Repository]())
    
    fileprivate var currentPage = 1
    
    var interactor : RepositoryListInteractorType? {
        didSet {
            bind()
        }
    }
    
    weak var router : RepositoryListRouterType?
    
    fileprivate var disposeBag = DisposeBag()
    
}


extension RepositoryListPresenter {
    
    fileprivate func bind() {
        currentState.asObservable()
                    .subscribe(onNext: { [weak self] in
                        if $0 == .loadingFirst || $0 == .loadingMore {
                            self?.fetchRepositories()
                        }
                    })
                    .addDisposableTo(disposeBag)
    }
    
    private func fetchRepositories() {
        interactor?.repositories(fromPage: currentPage)
                    .subscribe(onNext: { [weak self] fetchedRepositories in
                        if fetchedRepositories.count > 0 {
                            guard let strongSelf = self else { return }
                            strongSelf.repositories.value = strongSelf.repositories.value + fetchedRepositories
                            strongSelf.currentPage += 1
                            strongSelf.currentState.value = .showingRepositories
                        }
                    },
                    onError: { [weak self] _ in
                        if let currentRepositories = self?.repositories.value, currentRepositories.count > 0 {
                            self?.currentState.value = .showingRepositories
                        }
                        else {
                            self?.currentState.value = .showingError
                        }
                    })
                    .addDisposableTo(disposeBag)
    }
    
}

extension RepositoryListPresenter : RepositoryListPresenterType {
    
    func onInfoButtonTap() {
        router?.onInfoScreenRequest()
    }
    
}

extension RepositoryListPresenter : TableViewSelectionHandler {
    
    func onSelection(ofIndex index: Int, atSection section: Int, withModel model: Any?) {
        if let repository = model as? Repository {
            router?.onRepositorySelection(repository)
        }
    }
    
}
