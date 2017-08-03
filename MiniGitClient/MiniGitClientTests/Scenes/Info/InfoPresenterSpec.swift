//
//  InfoPresenterSpec.swift
//  MiniGitClient
//
//  Created by Andre Faria on 28/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
@testable import MiniGitClient

private class MockRouter : InfoRouterType {
    
    var didDismiss = false

    var didOpenGitHubPage = false
    
    var didOpenMailCompose = false
    
    func dismissController(_ controller: UIViewController) {
        didDismiss = true
    }
    
    func openGitHubPage() {
        didOpenGitHubPage = true
    }
    
    func openMailCompose() {
        didOpenMailCompose = true
    }
    
}

class InfoPresenterSpec: QuickSpec {
    
    override func spec() {
        
        describe("The InfoPresenter") { 
            
            var presenter = InfoPresenter()
            
            var router = MockRouter()
                        
            beforeEach {
                presenter = InfoPresenter()
                router = MockRouter()
                presenter.router = router
            }

            context("router") {
                
                it("opens the GitHub page when the first row of the second section is selected") {
                    presenter.onSelection(ofIndex: 0, atSection: 1)
                    expect(router.didOpenGitHubPage).to(beTrue())
                }
                
                it("opens the mail compose UI when the second row of the second section is selected") {
                    presenter.onSelection(ofIndex: 1, atSection: 1)
                    expect(router.didOpenMailCompose).to(beTrue())
                }
            
            }
            
        }
        
    }
    
}
