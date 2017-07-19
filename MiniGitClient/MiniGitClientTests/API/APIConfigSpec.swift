//
//  MainAPIConfigSpec.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 20/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
@testable import MiniGitClient

class APIConfigSpec: QuickSpec {
    
    override func spec() {
        
        describe("The API Config") {
            
            context("knows", { 
                
                it("the search URL path") {
                    guard let path = MainAPIConfig.shared.urlString(with: .search) else { fail(); return }
                    expect(URL(string: path)).toNot(beNil())
                }
                
            })
            
        }
        
    }
    
}
