/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

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
        closeButton.rx
                    .tap
                    .subscribe(onNext: { [weak self] in
                        self?.close()
                    })
                    .addDisposableTo(disposeBag)
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
