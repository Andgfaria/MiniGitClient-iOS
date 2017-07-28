//
//  InfoLinkCellViewModel.swift
//  MiniGitClient
//
//  Created by Andre Faria on 28/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
@testable import MiniGitClient

class InfoLinkCellViewModelSpec: QuickSpec {
    
    override func spec() {
        
        describe("The InfoLinkCellViewModel") { 
            
            context("configures", { 
                
                it("a UITableViewCell to have a link style") {
                    let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                    InfoLinkCellViewModel.configureCell(cell, withText: "Test", andColor: .blue)
                    expect(cell.textLabel?.text) == "Test"
                    expect(cell.textLabel?.textColor) == .blue
                }
                
            })
            
        }
        
    }
    
}
