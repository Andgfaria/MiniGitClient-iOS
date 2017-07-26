//
//  PullRequestSpec.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 10/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
@testable import MiniGitClient

class PullRequestSpec: QuickSpec {
    
    override func spec() {
        
        describe("The PullRequest") { 
            
            var pullRequest = PullRequest()
            
            beforeEach {
                pullRequest = PullRequest()
            }
            
            context("has", { 
                
                it("a title property") {
                    pullRequest.title = "Title"
                    expect(pullRequest.title) == "Title"
                }
                
                it("a body property") {
                    pullRequest.body = "Body"
                    expect(pullRequest.body) == "Body"
                }
                
                
                it("an url property") {
                    let url = URL(string: "http://www.pudim.com.br")
                    pullRequest.url = url
                    expect(url) == url
                }
                
                it("an user property") {
                    let user = RepositoryOwner()
                    pullRequest.user  = user
                    expect(pullRequest.user) == user
                }
                
            })
            
            context("can", { 
                
                let validJson : DataDict = ["title" : "Title",
                                            "body" : "Body",
                                            "url" : "http://www.pudim.com.br",
                                            "user" : ["login" : "André", "avatar_url" : "https://avatars0.githubusercontent.com/u/7774181?v=3"]]
                
                let emptyJson = DataDict()
                
                it("be created from a valid json dictionary") {
                    pullRequest = PullRequest(json: validJson)
                    expect(pullRequest.title) == validJson["title"] as? String
                    expect(pullRequest.body) == validJson["body"] as? String
                    expect(pullRequest.url) == URL(string: validJson["url"] as? String ?? "")
                    expect(pullRequest.user).toNot(beNil())
                }
                
                it("can be created from an invalid json holding the default properties") {
                    pullRequest = PullRequest(json: emptyJson)
                    expect(pullRequest.title).to(beEmpty())
                    expect(pullRequest.body).to(beEmpty())
                    expect(pullRequest.url).to(beNil())
                    expect(pullRequest.user).to(beNil())
                }
                
            })
            
            context("is", { 
                
                it("equatable") {
                    let secondPullRequest = PullRequest()
                    expect(pullRequest) == secondPullRequest
                }
                
                it("printable") {
                    expect(pullRequest.description).toNot(beEmpty())
                }
                
                it("debugPrintable") {
                    expect(pullRequest.debugDescription).toNot(beEmpty())
                }
                
            })
            
        }
        
    }
    
}
