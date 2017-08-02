//
//  InfoPresenter.swift
//  MiniGitClient
//
//  Created by Andre Faria on 27/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit

protocol InfoRouterType : class {
    func dismissController(_ controller : UIViewController)
    func openGitHubPage()
    func openMailCompose()
}


class InfoPresenter : NSObject {
    
    weak var router : InfoRouterType?
    
}

extension InfoPresenter : InfoPresenterType {
    
    func onSelection(ofIndex index: Int, atSection section: Int) {
        if section == 1 {
            index == 0 ? router?.openGitHubPage() : router?.openMailCompose()
        }
    }
    
    func onDismissButtonTapped(sender: InfoViewController) {
        router?.dismissController(sender)
    }
    
}


