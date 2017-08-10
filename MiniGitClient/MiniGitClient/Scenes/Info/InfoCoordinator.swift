/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

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
        viewController.canClose = UIDevice.current.userInterfaceIdiom != .pad
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
