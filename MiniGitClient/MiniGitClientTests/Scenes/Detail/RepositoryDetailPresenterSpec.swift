//
//  RepositoryDetailPresenterSpec.swift
//  MiniGitClient
//
//  Created by Andre Faria on 24/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
import RxSwift

@testable import MiniGitClient

private class MockInteractor : RepositoryDetailInteractorType {
    
    var shouldFail = false
    
    var fetchedPullRequests : Variable<(APIRequestResult,[PullRequest])> = Variable((APIRequestResult.success,[PullRequest]()))
    
    func loadPullRequests(ofRepository repository : Repository) {
        
        if shouldFail {
            fetchedPullRequests.value = (APIRequestResult.networkError,[PullRequest]())
        }
        else {
            var pullRequests = [PullRequest]()
            for _ in 1...10 {
                pullRequests.append(PullRequest())
            }
            fetchedPullRequests.value = (APIRequestResult.success,pullRequests)
        }
        
    }

}

private class MockRouter : RepositoryDetailRouterType {
    
    var didCallRouterMethod = false
    
    func onPullRequestSelection(_ pullRequest: PullRequest) {
        didCallRouterMethod = true
    }
}

class RepositoryDetailPresenterSpec: QuickSpec {
    
    override func spec() {
        
        describe("The RepositoryDetailPresenter") { 
            
            var testRepository = Repository()
            
            var presenter : RepositoryDetailPresenter?
            
            var mockInteractor = MockInteractor()
            
            var mockRouter = MockRouter()
                        
            beforeEach {
                testRepository = Repository()
                testRepository.name = "Name"
                testRepository.info = "Info"
                testRepository.url = URL(string: "http://www.pudim.com.br/")
                
                presenter = RepositoryDetailPresenter(repository: testRepository)
                mockInteractor = MockInteractor()
                mockRouter = MockRouter()
                presenter?.interactor = mockInteractor
                presenter?.router = mockRouter
            }
            
            context("has", { 
                
                it("a repository property") {
                    expect(presenter?.repository.value).toNot(beNil())
                }
                
                it("a pull requests property") {
                    expect(presenter?.pullRequests.value).toNot(beNil())
                }
                
            })
            
            context("when loading") {
                
                it("retrieves the pull requests from the interactor") {
                    presenter?.currentState.value = .loading
                    expect(presenter?.pullRequests.value.count) == 10
                }
                
            }
            
            context("after retrieving the pull requests from the interactor", {
                
                it("changes the current state to loaded when successfull") {
                    mockInteractor.loadPullRequests(ofRepository: Repository())
                    expect(presenter?.currentState.value) == .showingPullRequests
                }
                
                it("changes the current state to showingRetryOption after a failure") {
                    mockInteractor.shouldFail = true
                    mockInteractor.loadPullRequests(ofRepository: Repository())
                    expect(presenter?.currentState.value) == .onError
                }
                
            })
            
            context("passes", {
                
                it("the pull request to the router") {
                    presenter?.onSelection(ofIndex: 0, atSection: 0, withModel: PullRequest())
                    expect(mockRouter.didCallRouterMethod).to(beTrue())
                }
                
            })
            
            
//            context("as an UITableViewDataSource", { 
//                
//                it("returns 1 section") {
//                    guard let tableView = tableView else { fail(); return }
//                    presenter?.registerTableView(tableView)
//                    presenter?.loadPullRequests()
//                    tableView.reloadData()
//                    expect(tableView.numberOfSections) == 1
//                }
//                
//                it("returns the number of rows as the number of pull requests in the interactor") {
//                    guard let tableView = tableView else { fail(); return }
//                    presenter?.registerTableView(tableView)
//                    presenter?.loadPullRequests()
//                    tableView.reloadData()
//                    expect(tableView.numberOfRows(inSection: 0)) == presenter?.interactor?.fetchedPullRequests.value.1.count
//                }
//                
//                it("return a PullRequestTableViewCell") {
//                    guard let tableView = tableView else { fail(); return }
//                    presenter?.registerTableView(tableView)
//                    presenter?.loadPullRequests()
//                    tableView.reloadData()
//                    let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
//                    expect(cell).to(beAKindOf(PullRequestTableViewCell.self))
//                }
//                
//            })
//            
//            context("as an UITableViewDelegate", { 
//                
//                it("call its router upon cell selection") {
//                    guard let tableView = tableView else { fail(); return }
//                    presenter?.registerTableView(tableView)
//                    presenter?.loadPullRequests()
//                    tableView.reloadData()
//                    presenter?.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
//                    expect(mockRouter.didCallRouterMethod).to(beTrue())
//                }
//                
//            })
            
            context("returns", {
                
                it("the repository name and url, if available") {
                    guard let items = presenter?.shareItems else { fail(); return }
                    expect(items.count) == 2
                    expect(items[0]).to(beAKindOf(String.self))
                    expect(items[1]).to(beAKindOf(URL.self))
                }
                
                it("the repository name if the url is unavailable") {
                    testRepository.url = nil
                    presenter = RepositoryDetailPresenter(repository: testRepository)
                    guard let items = presenter?.shareItems else { fail(); return }
                    expect(items.count) == 1
                    expect(items[0]).to(beAKindOf(String.self))
                }
                
            })
            
        }
        
    }
    
}
