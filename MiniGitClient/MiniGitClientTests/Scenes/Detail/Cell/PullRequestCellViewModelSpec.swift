//
//  PullRequestCellViewModelSpec.swift
//  MiniGitClient
//
//  Created by Andre Faria on 19/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
@testable import MiniGitClient

class PullRequestCellViewModelSpec: QuickSpec {
    
    override func spec() {
        
        describe("The PullRequestCellViewModel") {
            
            var testPullRequest = PullRequest()
            
            beforeEach {
                testPullRequest.title = "Test"
                testPullRequest.body = "Test Body"
                var testUser = User()
                testUser.name = "André"
                testUser.avatarURL = URL(string: "https://camo.mybb.com/e01de90be6012adc1b1701dba899491a9348ae79/687474703a2f2f7777772e6a71756572797363726970742e6e65742f696d616765732f53696d706c6573742d526573706f6e736976652d6a51756572792d496d6167652d4c69676874626f782d506c7567696e2d73696d706c652d6c69676874626f782e6a7067")
                testPullRequest.user = testUser
            }
            
            context("configures", { 
                
                it("the PullRequestTableViewCell") {
                    let cell = PullRequestTableViewCell(style: .default, reuseIdentifier: nil)
                    PullRequestCellViewModel.configure(cell, withPullRequest: testPullRequest)
                    expect(cell.titleLabel.text) == testPullRequest.title
                    expect(cell.bodyTextView.text) == testPullRequest.body
                    expect(cell.authorLabel.text) == testPullRequest.user?.name
                    expect(cell.avatarImageView.image).toEventuallyNot(beNil(), timeout: 30.0, pollInterval: 10.0)
                }
                
            })
            
        }
        
    }
    
}
