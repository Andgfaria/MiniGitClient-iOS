//
//  RepositoryListTableViewCellSpec.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 30/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
@testable import MiniGitClient

class RepositoryListTableViewCellSpec: QuickSpec {
    
    override func spec() {
        
        describe("The RepositoryListTableViewCell") { 
            
            var cell = RepositoryListTableViewCell()
            
            beforeEach {
                cell = RepositoryListTableViewCell()
            }
            
            context("has", { 
                
                it("8 subviews") {
                    expect(cell.contentView.subviews.count) == 8
                }
                
                it("has 3 UIImageViews (2 private ones)") {
                    expect(cell.contentView.subviews.flatMap { $0 as? UIImageView }.count) == 3
                }
                
                it("has a title label") {
                    expect(cell.titleLabel).toNot(beNil())
                }
                
                it("has an info label") {
                    expect(cell.infoLabel).toNot(beNil())
                }
                
                it("has a stars count label") {
                    expect(cell.starsCountLabel).toNot(beNil())
                }
                
                it("has a forks count label") {
                    expect(cell.forksCountLabel).toNot(beNil())
                }
                
                it("has an avatar image view") {
                    expect(cell.avatarImageView).toNot(beNil())
                }
                
                it("has a repository user label") {
                    expect(cell.repositoryUserLabel).toNot(beNil())
                }
                
            })
            
        }
        
    }
    
}
