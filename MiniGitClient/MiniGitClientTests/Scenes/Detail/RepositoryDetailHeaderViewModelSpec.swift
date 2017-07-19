//
//  RepositoryDetailHeaderViewModelSpec.swift
//  MiniGitClient
//
//  Created by Andre Faria on 19/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
@testable import MiniGitClient

class RepositoryDetailHeaderViewModelSpec: QuickSpec {
    
    override func spec() {
        
        describe("The RepositoryDetailHeaderViewModel") { 
            
            let headerView = RepositoryDetailHeaderView()
            
            context("configures", { 
                
                it("the RepositoryDetailHeaderView") {
                    var testRepository = Repository()
                    testRepository.name = "Name"
                    testRepository.info = "Info"
                    RepositoryDetailHeaderViewModel.configureHeader(headerView, withRepository: testRepository)
                    expect(headerView.nameLabel.text) == testRepository.name
                    expect(headerView.infoLabel.text) == testRepository.info
                }
                
            })
            
        }
        
    }
    
}
