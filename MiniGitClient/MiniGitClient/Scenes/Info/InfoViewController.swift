/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import UIKit
import RxSwift
import RxCocoa

class InfoViewController: UIViewController {
    
    fileprivate var tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    weak var presenter : InfoPresenterType?

    weak var tableViewModel : InfoTableViewModelType?
    
    var canClose = false
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = R.string.info.title()
        if canClose {
            addCloseComponent(toThe: .right)
        }
        setup(withViews: [tableView])
        tableViewModel?.register(tableView: tableView)
    }

}

extension InfoViewController : ViewCodable {
    
    func setupConstraints() {
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupAccessibilityIdentifiers() {
        tableView.accessibilityIdentifier = "InfoTableView"
        self.navigationItem.rightBarButtonItem?.accessibilityIdentifier = "InfoDoneButton"
    }
    
}

extension InfoViewController : Closable { }
