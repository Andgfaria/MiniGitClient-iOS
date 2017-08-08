//
//  InfoPresenter.swift
//  MiniGitClient
//
//  Created by Andre Faria on 27/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit

class InfoPresenter : NSObject {
    
    weak var router : InfoRouterType?
    
}

extension InfoPresenter : InfoPresenterType {
    
    func onSelection(ofIndex index: Int, atSection section: Int, withModel model : Any?) {
        if section == 1 {
            index == 0 ? router?.openGitHubPage() : router?.openMailCompose()
        }
    }
    
}


