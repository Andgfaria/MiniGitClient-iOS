//
//  RepositoryOwnerSpec.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 20/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
@testable import MiniGitClient

class RepositoryOwnerSpec: QuickSpec {
    
    override func spec() {
        
        describe("The Repository Owner") {
            
            var repoOwner : RepositoryOwner?
            
            let url = URL(string: "https://avatars0.githubusercontent.com/u/7774181?v=3")
            
            beforeEach {
                repoOwner = nil
            }
            
            context("has", { 
                
                it("a name property") {
                    repoOwner = RepositoryOwner()
                    repoOwner?.name = "André"
                    expect(repoOwner?.name) == "André"
                }
                
                it("an avatar url property") {
                    repoOwner = RepositoryOwner()
                    repoOwner?.avatarURL = url
                    expect(repoOwner?.avatarURL) == url
                }
                
            })
            
            context("can", { 
                
                let validJson : [String : Any] = ["login" : "André", "avatar_url" : "https://avatars0.githubusercontent.com/u/7774181?v=3"]
                
                let emptyJson = [String : Any]()
                
                it("be created from a valid JSON dictionary") {
                    repoOwner = RepositoryOwner(json: validJson)
                    expect(repoOwner?.name) == validJson["login"] as? String
                    expect(repoOwner?.avatarURL) == url
                }
                
                it("be created from an invalid JSON holding the default values") {
                    repoOwner = RepositoryOwner(json: emptyJson)
                    expect(repoOwner?.name).to(beEmpty())
                    expect(repoOwner?.avatarURL).to(beNil())
                }
                
                
            })
            
            context("is", {
                
                it("equatable") {
                    repoOwner = RepositoryOwner()
                    let secondRepoOwner = RepositoryOwner()
                    expect(repoOwner) == secondRepoOwner
                }
                
                it("printable") {
                    repoOwner = RepositoryOwner()
                    expect(repoOwner?.description).toNot(beEmpty())
                }
                
                it("debug printable") {
                    repoOwner = RepositoryOwner()
                    expect(repoOwner?.debugDescription).toNot(beEmpty())
                }
                
            })
            
        }
        
        
    }
    
    
}
