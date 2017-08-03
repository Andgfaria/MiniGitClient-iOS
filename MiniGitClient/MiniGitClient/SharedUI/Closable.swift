//
//  Dismissable.swift
//  MiniGitClient
//
//  Created by Andre Faria on 03/08/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum CloseNavigationItemPosition : Int {
    case left, right
}

protocol Closable : class {
    var canClose : Bool { get set }
    var disposeBag : DisposeBag { get set }
    func addCloseComponent(toThe position : CloseNavigationItemPosition)
    func close()
}

extension Closable where Self : UIViewController {
    
    func addCloseComponent(toThe position : CloseNavigationItemPosition) {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        closeButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.close()
        }).addDisposableTo(disposeBag)
        switch position {
        case .left:
            navigationItem.leftBarButtonItem = closeButton
        case .right:
            navigationItem.rightBarButtonItem = closeButton
        }
    }
    
    func close() {
        dismiss(animated: true, completion: nil)
    }
    
}
