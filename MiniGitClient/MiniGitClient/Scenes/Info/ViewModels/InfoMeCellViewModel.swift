//
//  InfoMeCellViewModel.swift
//  MiniGitClient
//
//  Created by Andre Faria on 27/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit

struct InfoMeCellViewModel {
    
    private init() { }
    
    static func configureCell(_ cell : UITableViewCell) {
        cell.imageView?.image = R.image.me()
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.layer.masksToBounds = true
        cell.imageView?.layer.cornerRadius = 22
        cell.imageView?.frame = CGRect(x: 10, y: 10, width: 5, height: 5)
        cell.textLabel?.text = R.string.info.me()
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        cell.selectionStyle = .none
    }
    
}
