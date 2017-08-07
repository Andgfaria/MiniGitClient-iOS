//
//  RepositoryListPresenterSpec.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 04/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
import RxSwift
@testable import MiniGitClient

private class MockInteractor : RepositoryListInteractorType {
    
    var repositoriesStore : RepositoriesStoreType = RepositoriesStore.shared

    var fetchResults : Variable<(APIRequestResult,[Repository])> = Variable((APIRequestResult.success,[Repository]()))
    
    var shouldFail = false
    
    func loadRepositories() {
        if shouldFail {
            fetchResults.value = (APIRequestResult.networkError,[Repository]())
        }
        else {
            let repository = Repository()
            var repositories = [Repository]()
            for _ in 0...10 {
                repositories.append(repository)
            }
            fetchResults.value = (APIRequestResult.success,repositories)
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
                
                it("changes the view controller state to showing repositories on success") {
                    mockInteractor.loadRepositories()
                    expect(presenter.currentState.value) == RepositoryListState.showingRepositories
                }
                
                it("changes the view controller state to showingError on first load") {
                    mockInteractor.shouldFail = true
                    mockInteractor.loadRepositories()
                    expect(presenter.currentState.value) == RepositoryListState.showingError
                }
                
                it("updates the repository list table view") {
                    presenter.repositories.value = [Repository()]
                    expect(viewController.tableViewModel?.tableView(UITableView(), numberOfRowsInSection: 0)) == 1
                }
                
            })
            
        }
        
    }
    
}
