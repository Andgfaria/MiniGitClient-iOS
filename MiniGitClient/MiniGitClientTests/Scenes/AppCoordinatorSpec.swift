//
//  AppCoordinatorSpec.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 30/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
@testable import MiniGitClient

class AppCoordinatorSpec: QuickSpec {
    
    override func spec() {
        
        describe("The App Coordinator") { 
            
            it("begins the app flow with a UISplitViewController") {
                AppCoordinator().start()
                expect(UIApplication.shared.delegate?.window??.rootViewController is UISplitViewController).to(beTrue())
            }
            
        }
        
    }
    
}
