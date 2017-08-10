/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

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
