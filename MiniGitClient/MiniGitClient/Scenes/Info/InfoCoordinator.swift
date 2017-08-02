//
//  InfoCoordinator.swift
//  MiniGitClient
//
//  Created by Andre Faria on 26/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

fileprivate struct InfoScene {
    
    let viewController = InfoViewController(nibName: nil, bundle: nil)
    
    let presenter = InfoPresenter()
    
    let tableViewModel = InfoTableViewModel()
    
    init() {
        tableViewModel.selectionHandler = presenter
        viewController.presenter = presenter
        viewController.tableViewModel = tableViewModel
    }
    
}

class InfoCoordinator : NSObject {

    fileprivate let scene = InfoScene()
    
    weak var viewController : UIViewController?
    
    weak var senderItem : UIBarButtonItem?
    
    required init(viewController : UIViewController, senderItem : UIBarButtonItem) {
        super.init()
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
    
    func openGitHubPage() {
        if let url = URL(string: "https://github.com/Andgfaria/MiniGitClient-iOS") {
            let safariController = SFSafariViewController(url: url)
            safariController.modalPresentationStyle = .pageSheet
            scene.viewController.present(safariController, animated: true, completion: nil)
        }
    }
    
    func openMailCompose() {
        if MFMailComposeViewController.canSendMail() {
            let mailController = MFMailComposeViewController()
            mailController.setSubject("MiniGitClient")
            mailController.setToRecipients(["andre.gimenez.faria@gmail.com"])
            mailController.mailComposeDelegate = self
            scene.viewController.present(mailController, animated: true, completion: nil)
        }
    }
    
}

extension InfoCoordinator : MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
