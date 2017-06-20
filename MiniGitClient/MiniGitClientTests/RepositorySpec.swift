//
//  RepositorySpec.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 20/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
@testable import MiniGitClient

class RepositorySpec: QuickSpec {
    
    override func spec() {
    
        describe("The Repository") { 
            
            var repo : Repository?
            
            beforeEach {
                repo = nil
            }
            
            context("has", closure: { 
                
                it("a name property") {
                    repo = Repository()
                    repo?.name = "Name"
                    expect(repo?.name) == "Name"
                }
                
                it("a info property") {
                    var repo = Repository()
                    repo.info = "Description"
                    expect(repo.info) == "Description"
                }
                
                it("a stars count property") {
                    repo = Repository()
                    repo?.starsCount = 13
                    expect(repo?.starsCount) == 13
                }
                
                it("a forks count property") {
                    repo = Repository()
                    repo?.forksCount = 13
                    expect(repo?.forksCount) == 13
                }
                
            })
            
            context("can", closure: {
                
                let validJson : [String : Any] = ["name" : "Name", "description" : "Description", "stargazers_count" : 13, "forks_count" : 13]
                
                let emptyJson = [String : Any]()
                
                it("be created from a JSON dictionary") {
                    repo = Repository(json: validJson)
                    expect(repo?.name) == validJson["name"] as? String
                    expect(repo?.info) == validJson["description"] as? String
                    expect(repo?.starsCount) == validJson["stargazers_count"] as? Int
                    expect(repo?.forksCount) == validJson["forks_count"] as? Int
                }
                
                it("be created from an invalid JSON dictionary and hold the default values") {
                    repo = Repository(json: emptyJson)
                    expect(repo?.name).to(beEmpty())
                    expect(repo?.info).to(beEmpty())
                    expect(repo?.starsCount) == 0
                    expect(repo?.forksCount) == 0
                }
                
            })
            
            context("is", {
                
                it("equatable") {
                   repo =  Repository()
                   let secondRepo = Repository()
                   expect(repo) == secondRepo
                }
                
                it("printable") {
                    repo = Repository()
                    expect(repo?.description).notTo(beEmpty())
                }
                
                it("debug printable") {
                    repo = Repository()
                    expect(repo?.debugDescription).notTo(beEmpty())
                }
                
            })
        }
        
    }
    
}
