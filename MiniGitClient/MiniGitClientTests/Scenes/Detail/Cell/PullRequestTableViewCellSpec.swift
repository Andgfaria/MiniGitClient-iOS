/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

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
