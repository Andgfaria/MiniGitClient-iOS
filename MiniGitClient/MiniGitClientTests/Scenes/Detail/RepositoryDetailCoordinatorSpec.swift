//
//  RepositoryDetailCoordinatorSpec.swift
//  MiniGitClient
//
//  Created by Andre Faria on 25/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
import SafariServices
@testable import MiniGitClient

class RepositoryDetailCoordinatorSpec: QuickSpec {
    
    override func spec() {
        
        describe("The RepositoryDetailCoordinator") { 
            
            var splitViewController = UISplitViewController()
            
            var coordinator : RepositoryDetailCoordinator?
            
            beforeEach {
                splitViewController = UISplitViewController()
                splitViewController.viewControllers = [UIViewController()]
                coordinator = RepositoryDetailCoordinator(repository: Repository(), splitViewController: splitViewController)
            }
            
            context("shows", { 
                
                it("a RepositoryDetailViewController as a detail when starting") {
                    coordinator?.start()
                    guard let navController = splitViewController.viewControllers[1] as? UINavigationController else { fail(); return }
                    expect(navController.viewControllers.first).to(beAKindOf(RepositoryDetailViewController.self))
                }
                
                it("a SafariViewController when routing a pull request selection") {
                    var testPullRequest = PullRequest()
                    testPullRequest.url = URL(string: "http://www.pudim.com.br")
                    coordinator?.start()
                    coordinator?.openPullRequest(RepositoryDetailPresenter(repository: Repository()), testPullRequest)
                }
                
            })
            
        }
        
    }
    
}
