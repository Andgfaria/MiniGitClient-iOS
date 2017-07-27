//
//  InfoCoordinator.swift
//  MiniGitClient
//
//  Created by Andre Faria on 26/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit

fileprivate struct InfoScene {
    
    let viewController = InfoViewController(nibName: nil, bundle: nil)
    
    let presenter = InfoPresenter()
    
    init() {
        viewController.presenter = presenter
    }
    
}

class InfoCoordinator {

    fileprivate let scene = InfoScene()
    
    weak var viewController : UIViewController?
    
    weak var senderItem : UIBarButtonItem?
    
    required init(viewController : UIViewController, senderItem : UIBarButtonItem) {
        self.viewController = viewController
        self.senderItem = senderItem
        self.scene.presenter.router = self
    }
    
}

extension InfoCoordinator : Coordinator {
    
    func start() {
        let navigationController = UINavigationController(rootViewController: scene.viewController)
        navigationController.modalPresentationStyle = .popover
        navigationController.popoverPresentationController?.barButtonItem = senderItem
        viewController?.present(navigationController, animated: true)
    }
    
}

extension InfoCoordinator : InfoRouterType {
    
    func dismissController(_ controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
