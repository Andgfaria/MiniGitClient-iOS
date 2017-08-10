//
//  RepositoryListCellViewModelSpec.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 04/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

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
