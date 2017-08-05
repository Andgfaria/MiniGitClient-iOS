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

fileprivate class MockInteractor : RepositoryListInteractorType {
    
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
            
            var viewController = RepositoryListViewController(nibName: nil, bundle: nil)
            
            var tableView = UITableView(frame: CGRect.zero, style: .plain)
            
            beforeEach {
                tableView = UITableView(frame: CGRect.zero, style: .plain)
                presenter = RepositoryListPresenter()
                mockInteractor = MockInteractor()
                viewController = RepositoryListViewController(nibName: nil, bundle: nil)
                presenter.interactor = mockInteractor
                presenter.viewController = viewController
            }
            
            context("after retrieving the repositories from the interactor", { 
                
                it("changes the view controller state to showing repositories on success") {
                    mockInteractor.loadRepositories()
                    expect(presenter.currentState.value) == RepositoryListState.showingRepositories
                }
                
                it("changes the view controller state to showingError on first load") {
                    mockInteractor.shouldFail = true
            //        presenter.interactor = mockInteractor
                    mockInteractor.loadRepositories()
                    expect(presenter.currentState.value) == RepositoryListState.showingError
                }
                
            })
            
//            context("as a UITableViewDataSource", { 
//                
//                it("returns 1 section") {
//                    presenter.registerTableView(tableView)
//                    presenter.loadRepositories()
//                    tableView.reloadData()
//                    expect(tableView.numberOfSections) == 1
//                }
//                
//                it("returns the number of rows as the number of repositories from the interactor") {
//                    presenter.registerTableView(tableView)
//                    presenter.loadRepositories()
//                    tableView.reloadData()
//                    expect(tableView.numberOfRows(inSection: 0)) == presenter.interactor?.fetchResults.value.1.count
//                }
//                
//                it("returns a RepositoryListTableViewCelll") {
//                    presenter.registerTableView(tableView)
//                    presenter.loadRepositories()
//                    tableView.reloadData()
//                    let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RepositoryListTableViewCell
//                    expect(cell).toNot(beNil())
//                }
//                
//            })
            
        }
        
    }
    
}
