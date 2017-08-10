/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import Quick
import Nimble
import RxSwift
@testable import MiniGitClient

private class MockInteractor : RepositoryListInteractorType {
    
    var repositoriesStore : RepositoriesStoreType = RepositoriesStore.shared
    
    var shouldFail = false
    
    func repositories(fromPage page: Int) -> Observable<[Repository]> {
        if shouldFail {
            return Observable.error(APIRequestError.networkError)
        }
        else {
            var repositories = [Repository]()
            for _ in 0...10 {
                repositories.append(Repository())
            }
            return Observable.just(repositories)
        }
    }
    
}

class RepositoryListPresenterSpec: QuickSpec {
    
    override func spec() {
        
        describe("The RepositoryListPresenter") { 
            
            var presenter = RepositoryListPresenter()
            
            var mockInteractor = MockInteractor()
            
            var tableViewModel = RepositoryListTableViewModel()
            
            var viewController = RepositoryListViewController(nibName: nil, bundle: nil)
            
            beforeEach {
                presenter = RepositoryListPresenter()
                mockInteractor = MockInteractor()
                tableViewModel = RepositoryListTableViewModel()
                viewController = RepositoryListViewController(nibName: nil, bundle: nil)
                viewController.tableViewModel = tableViewModel
                viewController.presenter = presenter
                presenter.interactor = mockInteractor
                viewController.view.layoutIfNeeded()
            }
            
            context("after retrieving the repositories from the interactor", { 
                
                it("changes the state to showing repositories on success") {
                    expect(presenter.currentState.value) == RepositoryListState.showingRepositories
                }
                
                it("changes the state to showingError on first load") {
                    mockInteractor.shouldFail = true
                    presenter.repositories.value = [Repository]()
                    presenter.currentState.value = .loadingFirst
                    expect(presenter.currentState.value) == RepositoryListState.showingError
                }
                
                it("changes the state to showingRepositories after a failed second load") {
                    mockInteractor.shouldFail = true
                    presenter.currentState.value = .loadingMore
                    expect(presenter.currentState.value) == RepositoryListState.showingRepositories
                }
                
                it("accumulates repositories after each load") {
                    let firstLoadCount = presenter.repositories.value.count
                    presenter.currentState.value = .loadingMore
                    let secondLoadCount = presenter.repositories.value.count
                    expect(secondLoadCount).to(beGreaterThan(firstLoadCount))
                    presenter.currentState.value = .loadingMore
                    let thirdLoadCount = presenter.repositories.value.count
                    expect(thirdLoadCount).to(beGreaterThan(secondLoadCount))
                }
                
                it("updates the repository list table view") {
                    presenter.repositories.value = [Repository()]
                    expect(viewController.tableViewModel?.tableView(UITableView(), numberOfRowsInSection: 0)) == 1
                }
                
            })
            
        }
        
    }
    
}
