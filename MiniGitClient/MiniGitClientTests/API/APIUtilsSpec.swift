//
//  APIUtilsSpec.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 24/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
@testable import MiniGitClient

class APIUtilsSpec: QuickSpec {
    
    override func spec() {
        
        describe("The APIUtils file") { 
            
            context("has", { 
                
                it("a typealias for the [String : Any] type") {
                    var typeAliasedObject = DataDict()
                    typeAliasedObject["test"] = 1
                    expect(typeAliasedObject["test"] as? Int) == 1
                }
                
            })
            
        }
        
    }
    
}
