//
//  LoadMoreViewSpec.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 05/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
@testable import MiniGitClient

class LoadMoreViewSpec: QuickSpec {
    
    override func spec() {
        
        describe("The LoadMoreView") { 
            
            var loadMoreView = LoadMoreView()
            
            var activityIndicator : UIActivityIndicatorView?
            
            var loadMoreButton : UIButton?
            
            beforeEach {
                loadMoreView = LoadMoreView()
                activityIndicator = loadMoreView.subviews.flatMap { $0 as? UIActivityIndicatorView }.first
                loadMoreButton = loadMoreView.subviews.flatMap { $0 as? UIButton }.first
            }
            
            context("has", {
                
                it("2 subviews") {
                    expect(loadMoreView.subviews.count) == 2
                }
                
                it("an activity indicator") {
                    expect(activityIndicator).toNot(beNil())
                }
                
                it("a load more button") {
                    expect(loadMoreButton).toNot(beNil())
                }
                
                it("a load title property that changes the button title") {
                    loadMoreView.loadTitle = "Test"
                    expect(loadMoreButton?.title(for: .normal)) == "Test"
                }
                
            })
            
            context("state", { 
                
                it("hides the activity indicator when normal") {
                    loadMoreView.currentState.value = .normal
                    expect(activityIndicator?.isHidden).to(beTrue())
                    expect(loadMoreButton?.isHidden).to(beFalse())
                }
                
                it("hides the load button when loading") {
                    loadMoreView.currentState.value = .loading
                    expect(activityIndicator?.isHidden).to(beFalse())
                    expect(loadMoreButton?.isHidden).to(beTrue())
                }
                
            })
            
            context("runs", {
                
                it("a loading block when the button is pressed") {
                    var blockDidRun = false
                    loadMoreView.loadingBlock = { blockDidRun = true }
                    loadMoreButton?.sendActions(for: .touchUpInside)
                    expect(blockDidRun).to(beTrue())
                }
                
            })
            
        }
        
    }
    
}
