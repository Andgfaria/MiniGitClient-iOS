//
//  InfoMeCellViewModelSpec.swift
//  MiniGitClient
//
//  Created by Andre Faria on 28/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
@testable import MiniGitClient

class InfoMeCellViewModelSpec: QuickSpec {
    
    override func spec() {
        
         describe("The InfoMeCellViewModel") { 
            
            context("configures", { 
                
                it("a basic UITableViewCell to show my name and picture") {
                    let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                    InfoMeCellViewModel.configureCell(cell)
                    expect(cell.imageView?.image) == R.image.me()
                    expect(cell.textLabel?.text) == R.string.info.me()
                }
                
            })
            
        }
        
    }
    
}
