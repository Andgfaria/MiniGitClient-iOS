//
//  InfoLinkCellViewModel.swift
//  MiniGitClient
//
//  Created by Andre Faria on 27/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit

struct InfoLinkCellViewModel {
    
    private init() { }
    
    static func configureCell(_ cell : UITableViewCell, withText text : String, andColor color : UIColor) {
        cell.textLabel?.text = text
        cell.textLabel?.textColor = color
        cell.selectionStyle = .default
    }
    
}
