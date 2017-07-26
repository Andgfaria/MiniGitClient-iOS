//
//  PullRequestTableViewCellSpec.swift
//  MiniGitClient
//
//  Created by Andre Faria on 19/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
@testable import MiniGitClient

class PullRequestTableViewCellSpec: QuickSpec {
    
    override func spec() {
        
        describe("The Pull Request Table View Cell") { 
            
            var cell = PullRequestTableViewCell(style: .default, reuseIdentifier: nil)
            
            beforeEach {
                cell = PullRequestTableViewCell(style: .default, reuseIdentifier: nil)
            }
            
            context("has", { 
                
                it("a wrapper view") {
                    expect(cell.subviews.count) == 1
                    expect(cell.subviews.first).to(beAKindOf(UIView.self))
                }
                
                it("a title label") {
                    expect(cell.titleLabel).toNot(beNil())
                }
                
                it("a body textview") {
                    expect(cell.bodyTextView).toNot(beNil())
                }
                
                it("an avatar imageview") {
                    expect(cell.avatarImageView).toNot(beNil())
                }
                
                it("an author label") {
                    expect(cell.authorLabel).toNot(beNil())
                }
                
            })
            
        }
        
    }
    
}
