//
//  InfoViewControllerSpec.swift
//  MiniGitClient
//
//  Created by Andre Faria on 28/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
@testable import MiniGitClient

private class MockPresenter : InfoPresenterType {
    
    
    var didHandleDismissEvent = false

    
    func onSelection(ofIndex index: Int, atSection section: Int, withModel model : Any?) {
        
    }
    
    func onDismissButtonTapped(sender: InfoViewController) {
        didHandleDismissEvent = true
    }
}

class InfoViewControllerSpec: QuickSpec {
    
    override func spec() {
        
        describe("The InfoViewController") { 
            
            var controller = InfoViewController()
            
            var presenter = MockPresenter()
            
            beforeEach {
                controller = InfoViewController()
                presenter = MockPresenter()
                controller.presenter = presenter
                _ = controller.view
            }
            
            context("has", { 
                
                it("a tableView") {
                    expect(controller.view.subviews.first).to(beAKindOf(UITableView.self))
                }
                
            })
            
            context("is", { 
                
                it("closable") {
                    expect(controller).to(beAKindOf(Closable.self))
                }
                
            })

        }
        
        
    }
    
}
