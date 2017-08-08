/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import Quick
import Nimble
@testable import MiniGitClient

class RepositorySpec: QuickSpec {
    
    override func spec() {
    
        describe("The Repository") { 
            
            var repo = Repository()
            
            beforeEach {
                repo = Repository()
            }
            
            context("has", closure: { 
                
                it("a name property") {
                    repo.name = "Name"
                    expect(repo.name) == "Name"
                }
                
                it("a info property") {
                    repo.info = "Description"
                    expect(repo.info) == "Description"
                }
                
                it("a stars count property") {
                    repo.starsCount = 13
                    expect(repo.starsCount) == 13
                }
                
                it("a forks count property") {
                    repo.forksCount = 13
                    expect(repo.forksCount) == 13
                }
                
                it("an url property") {
                    let url = URL(string: "http://www.pudim.com.br")
                    repo.url = url
                    expect(repo.url) == url
                }
                
                it("an user property") {
                    let user = User()
                    repo.user = user
                    expect(repo.user) == user
                }
                
            })
            
            context("can", closure: {
                
                let validJson : DataDict = ["name" : "Name",
                                            "description" : "Description",
                                            "stargazers_count" : 13,
                                            "forks_count" : 13,
                                            "url" : "http://www.pudim.com.br",
                                            "owner" : [
                                                "name" : "André",
                                                "avatar_url" : nil
                                            ]]
                
                let emptyJson = DataDict()
                
                it("be created from a JSON dictionary") {
                    repo = Repository(json: validJson)
                    expect(repo.name) == validJson["name"] as? String
                    expect(repo.info) == validJson["description"] as? String
                    expect(repo.starsCount) == validJson["stargazers_count"] as? Int
                    expect(repo.forksCount) == validJson["forks_count"] as? Int
                    expect(repo.url) == URL(string: validJson["url"] as? String ?? "")
                    expect(repo.user).toNot(beNil())
                }
                
                it("be created from an invalid JSON dictionary and hold the default values") {
                    repo = Repository(json: emptyJson)
                    expect(repo.name).to(beEmpty())
                    expect(repo.info).to(beEmpty())
                    expect(repo.starsCount) == 0
                    expect(repo.forksCount) == 0
                    expect(repo.url).to(beNil())
                    expect(repo.user).to(beNil())
                }
                
            })
            
            context("is", {
                
                it("equatable") {
                   let secondRepo = Repository()
                   expect(repo) == secondRepo
                }
                
                it("printable") {
                    expect(repo.description).notTo(beEmpty())
                }
                
                it("debug printable") {
                    expect(repo.debugDescription).notTo(beEmpty())
                }
                
            })
        }
        
    }
    
}
