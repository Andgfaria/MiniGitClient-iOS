/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import Quick
import Nimble
@testable import MiniGitClient

class RepositoryListCellViewModelSpec: QuickSpec {
    
    override func spec() {
        
        describe("The RepositoryListCellViewModel") { 
            
            context("configures", { 
                
                var mockedRepository = Repository()
                
                beforeEach {
                    mockedRepository.name = "Test"
                    mockedRepository.info = "Test"
                    mockedRepository.starsCount = 1
                    mockedRepository.forksCount = 1
                    mockedRepository.user = User()
                    mockedRepository.user?.name = "André"
                    mockedRepository.user?.avatarURL = URL(string: "https://camo.mybb.com/e01de90be6012adc1b1701dba899491a9348ae79/687474703a2f2f7777772e6a71756572797363726970742e6e65742f696d616765732f53696d706c6573742d526573706f6e736976652d6a51756572792d496d6167652d4c69676874626f782d506c7567696e2d73696d706c652d6c69676874626f782e6a7067")
                }
                
                it("the RepositoryListTableViewCell") {
                    let cell = RepositoryListTableViewCell(style: .default, reuseIdentifier: nil)
                    RepositoryListCellViewModel.configure(cell, with: mockedRepository)
                    
                    expect(cell.titleLabel.text) == mockedRepository.name
                    expect(cell.infoLabel.text) == mockedRepository.info
                    expect(cell.starsCountLabel.text) == "\(mockedRepository.starsCount)"
                    expect(cell.forksCountLabel.text) == "\(mockedRepository.forksCount)"
                    expect(cell.repositoryUserLabel.text) == mockedRepository.user?.name
                    expect(cell.avatarImageView.image).toNotEventually(beNil(), timeout: 30.0, pollInterval: 10.0)
                }
                
            })
            
        }
        
    }
    
}
