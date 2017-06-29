//
//  EmptyViewSpec.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 28/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
@testable import MiniGitClient

class EmptyViewSpec: QuickSpec {
    
    override func spec() {
        
        var emptyView = EmptyView()
        
        describe("The Empty View") { 
            
            beforeEach {
                emptyView = EmptyView()
            }
            
            context("has", { 
                
                it("3 subviews") {
                    expect(emptyView.subviews.count) == 3
                }
                
                it("an activity indicator") {
                    expect(emptyView.subviews.flatMap { $0 as? UIActivityIndicatorView }.count) == 1
                }
                
                it("a message label") {
                    expect(emptyView.subviews.flatMap { $0 as? UILabel }.count) == 1
                }
                
                it("an action button") {
                    expect(emptyView.subviews.flatMap { $0 as? UIButton}.count) == 1
                }
                
                it("a message property") {
                    emptyView.message = "message"
                    expect(emptyView.message) == "message"
                }
                
                it("an action title property") {
                    emptyView.actionTitle = "title"
                    expect(emptyView.actionTitle) == "title"
                }
                
                it("an action block") {
                    emptyView.actionBlock = { print("hi") }
                    expect(emptyView.actionBlock).toNot(beNil())
                }
                
                it("a state property") {
                    expect(emptyView.currentState).toNot(beNil())
                }
                
            })
            
        }
        
    }
    
}
