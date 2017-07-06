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
            
            var button : UIButton?
            
            var label : UILabel?
            
            var activityIndicator : UIActivityIndicatorView?
            
            beforeEach {
                emptyView = EmptyView()
                button = emptyView.subviews.flatMap { $0 as? UIButton }.first
                label = emptyView.subviews.flatMap { $0 as? UILabel }.first
                activityIndicator = emptyView.subviews.flatMap { $0 as? UIActivityIndicatorView }.first
            }
            
            context("has", { 
                
                it("3 subviews") {
                    expect(emptyView.subviews.count) == 3
                }
                
                it("an activity indicator") {
                    expect(activityIndicator).toNot(beNil())
                }
                
                it("a message label") {
                    expect(label).toNot(beNil())
                }
                
                it("an action button") {
                    expect(button).toNot(beNil())
                }
                
                it("a message property that changes the label text") {
                    emptyView.message = "message"
                    expect(label?.text) == "message"
                }
                
                it("an action title property") {
                    emptyView.actionTitle = "title"
                    expect(button?.title(for: .normal)) == "title"
                }
                
            })
            
            context("state", {
                
                it("hides the label and button when loading") {
                    emptyView.currentState.value = .loading
                    expect(activityIndicator?.isHidden).to(beFalse())
                    expect(label?.isHidden).to(beTrue())
                    expect(button?.isHidden).to(beTrue())
                }
                
                it("shows the label and button when not loading") {
                    emptyView.currentState.value = .showingError
                    expect(activityIndicator?.isHidden).to(beTrue())
                    expect(label?.isHidden).to(beFalse())
                    expect(button?.isHidden).to(beFalse())
                }
                
            })
            
            context("runs") {
                
                it("an action block when the button is pressed") {
                    var blockDidRun = false
                    emptyView.actionBlock = { blockDidRun = true }
                    button?.sendActions(for: .touchUpInside)
                    expect(blockDidRun).to(beTrue())
                }

            }
            
        }
        
    }
    
}
