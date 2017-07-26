//
//  RepositoryDetailHeaderViewSpec.swift
//  MiniGitClient
//
//  Created by Andre Faria on 19/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
@testable import MiniGitClient

class RepositoryDetailHeaderViewSpec: QuickSpec {
    
    override func spec() {
        
        describe("The RepositoryDetailHeaderView") { 
            
            var headerView = RepositoryDetailHeaderView()
            
            var loadView : LoadMoreView?
            
            beforeEach {
                headerView = RepositoryDetailHeaderView()
                if let stackView = headerView.subviews.first as? UIStackView {
                    loadView = stackView.arrangedSubviews.flatMap{ $0 as? LoadMoreView }.first
                }
            }
            
            context("has", { 
                
                it("a wrapper stack view") {
                    expect(headerView.subviews.count) == 1
                    expect(headerView.subviews.first).to(beAKindOf(UIStackView.self))
                }
                
                it("has a name label") {
                    expect(headerView.nameLabel).toNot(beNil())
                }
                
                it("has an info label") {
                    expect(headerView.infoLabel).toNot(beNil())
                }
                
                it("has a load view") {
                    expect(loadView).toNot(beNil())
                }
                
            })
            
            context("layout", { 
                
                it("intrisic content size is calculated based on its labels and its state") {
                    let height = headerView.nameLabel.intrinsicContentSize.height + headerView.infoLabel.intrinsicContentSize.height + 114
                    expect(headerView.intrinsicContentSize.width) == headerView.bounds.size.width
                    expect(headerView.intrinsicContentSize.height) == height
                    headerView.currentState.value = .loaded
                    expect(headerView.intrinsicContentSize.width) == headerView.bounds.size.width
                    expect(headerView.intrinsicContentSize.height) == height - 48
                }
                
                it("updates the labels preferred max width") {
                    headerView.adjustLayout(withWidth: 100)
                    expect(headerView.nameLabel.preferredMaxLayoutWidth) == 100 - 32
                    expect(headerView.infoLabel.preferredMaxLayoutWidth) == headerView.nameLabel.preferredMaxLayoutWidth
                }
                
            })
            
            context("changes the view hierarchy") {
                
                it("in the loading state") {
                    headerView.currentState.value = .loading
                    expect(loadView?.currentState.value) == .loading
                    expect(loadView?.superview).toNot(beNil())
                }
                
                it("in the showing retry option state") {
                    headerView.currentState.value = .showingRetryOption
                    expect(loadView?.currentState.value) == .normal
                    expect(loadView?.superview).toNot(beNil())
                }
                
                it("in the loaded state") {
                    headerView.currentState.value = .loaded
                    expect(loadView?.superview).to(beNil())
                }
                
            }
        }
        
        
    }
    
}
