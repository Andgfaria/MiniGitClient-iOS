//
//  UserSpec.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 20/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
@testable import MiniGitClient

class UserSpec: QuickSpec {
    
    override func spec() {
        
        describe("The Repository Owner") {
            
            var repoUser = User()
            
            let url = URL(string: "https://avatars0.githubusercontent.com/u/7774181?v=3")
            
            beforeEach {
                repoUser = User()
            }
            
            context("has", { 
                
                it("a name property") {
                    repoUser.name = "André"
                    expect(repoUser.name) == "André"
                }
                
                it("an avatar url property") {
                    repoUser.avatarURL = url
                    expect(repoUser.avatarURL) == url
                }
                
            })
            
            context("can", { 
                
                let validJson : DataDict = ["login" : "André", "avatar_url" : "https://avatars0.githubusercontent.com/u/7774181?v=3"]
                
                let emptyJson = DataDict()
                
                it("be created from a valid JSON dictionary") {
                    repoUser = User(json: validJson)
                    expect(repoUser.name) == validJson["login"] as? String
                    expect(repoUser.avatarURL) == url
                }
                
                it("be created from an invalid JSON holding the default values") {
                    repoUser = User(json: emptyJson)
                    expect(repoUser.name).to(beEmpty())
                    expect(repoUser.avatarURL).to(beNil())
                }
                
                
            })
            
            context("is", {
                
                it("equatable") {
                    let secondRepoUser = User()
                    expect(repoUser) == secondRepoUser
                }
                
                it("printable") {
                    expect(repoUser.description).toNot(beEmpty())
                }
                
                it("debug printable") {
                    expect(repoUser.debugDescription).toNot(beEmpty())
                }
                
            })
            
        }
        
        
    }
    
    
}
