//
//  InfoCoordinator.swift
//  MiniGitClient
//
//  Created by Andre Faria on 26/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit

class InfoCoordinator {

    weak var viewController : UIViewController?
    
    weak var senderItem : UIBarButtonItem?
    
    required init(viewController : UIViewController, senderItem : UIBarButtonItem) {
        self.viewController = viewController
        self.senderItem = senderItem
    }
    
}

extension InfoCoordinator : Coordinator {
    
    func start() {
        let infoController = InfoViewController(nibName: nil, bundle: nil)
        let navigationController = UINavigationController(rootViewController: infoController)
        navigationController.modalPresentationStyle = .popover
        navigationController.popoverPresentationController?.barButtonItem = senderItem
        viewController?.present(navigationController, animated: true)
    }
    
}
