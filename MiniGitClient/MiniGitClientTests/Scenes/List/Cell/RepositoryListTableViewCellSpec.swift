/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

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
