//
//  RepositoryListCoordinatorSpec.swift
//  MiniGitClient
//
//  Created by Andre Faria on 26/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
@testable import MiniGitClient

class RepositoryListCoordinatorSpec: QuickSpec {
    
    override func spec() {
        
        describe("The RepositoryListCoordinator") { 
            
            var splitViewController = UISplitViewController(nibName: nil, bundle: nil)
            
            var coordinator : RepositoryListCoordinator?
            
            beforeEach {
                splitViewController = UISplitViewController(nibName: nil, bundle: nil)
                coordinator = RepositoryListCoordinator(splitViewController: splitViewController)
            }
            
            context("shows", { 
                
                it("the repository list screen as the master controller on start") {
                    coordinator?.start()
                    guard let navigationController = splitViewController.viewControllers[0] as? UINavigationController else { fail(); return }
                    expect(navigationController.viewControllers.first).to(beAKindOf(RepositoryListViewController.self))
                }
                
                it("the repository detail screen as the detail controller after a repository selection") {
                    coordinator?.start()
                    coordinator?.onRepositorySelection(Repository())//presenter(RepositoryListPresenter(), didSelectRepository: Repository())
                    guard let navigationController = splitViewController.viewControllers[1] as? UINavigationController else { fail(); return }
                    expect(navigationController.viewControllers.first).to(beAKindOf(RepositoryDetailViewController.self))
                }
                
            })
            
        }
        
    }
    
}
