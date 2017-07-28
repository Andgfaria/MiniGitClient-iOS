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

private class MockPresenter : NSObject, InfoPresenterType {
    
    var didRegisterTableView = false
    
    var didHandleDismissEvent = false
    
    func registerTableView(_ tableView: UITableView) {
        didRegisterTableView = true
    }
    
    func onDismissButtonTapped(sender: InfoViewController) {
        didHandleDismissEvent = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(style: .default, reuseIdentifier: nil)
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
                
                it("a done button according to the device idiom") {
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        expect(controller.navigationItem.rightBarButtonItem).to(beNil())
                    }
                    else {
                        expect(controller.navigationItem.rightBarButtonItem).toNot(beNil())
                    }
                }
                
            })
            
            
            context("presenter", { 
                
                it("register the tableview") {
                    expect(presenter.didRegisterTableView).to(beTrue())
                }
                
                it("handles done button tap event") {
                    controller.handleDoneTap()
                    expect(presenter.didHandleDismissEvent).to(beTrue())
                }
                
            })
        }
        
        
    }
    
}
