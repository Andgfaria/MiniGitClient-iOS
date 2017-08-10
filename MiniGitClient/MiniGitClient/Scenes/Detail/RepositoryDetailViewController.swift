/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import UIKit
import RxSwift

class RepositoryDetailViewController: UIViewController {

    weak var presenter : RepositoryDetailPresenterType?
    
    weak var tableViewModel : RepositoryDetailTableViewModelType?
    
    fileprivate let tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    fileprivate let headerView = RepositoryDetailHeaderView()
    
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewModel?.register(tableView: tableView)
        addShareButton()
        setup(withViews: [tableView])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustHeaderLayout()
    }

}

extension RepositoryDetailViewController {
    
    fileprivate func adjustHeaderLayout() {
        headerView.adjustLayout(withWidth: tableView.bounds.size.width)
        view.layoutIfNeeded()
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: headerView.intrinsicContentSize.height)
        tableView.tableHeaderView = headerView
    }

}

extension RepositoryDetailViewController {
    
    fileprivate func addShareButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share(sender:)))
    }
    
    func share(sender : UIBarButtonItem) {
        if let shareItems = presenter?.shareItems {
            let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
            activityViewController.popoverPresentationController?.barButtonItem = sender
            present(activityViewController, animated: true, completion: nil)
        }
    }
}

extension RepositoryDetailViewController : ViewCodable {
    
    func setupConstraints() {
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupStyles() {
        tableView.estimatedRowHeight = 56
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func bindComponents() {
        if let presenter = presenter {
            presenter.repository
                     .asObservable()
                     .subscribe(onNext: { [weak self] in
                        if let headerView = self?.headerView {
                            RepositoryDetailHeaderViewModel.configureHeader(headerView, withRepository: $0)
                        }
                     })
                    .addDisposableTo(disposeBag)
            presenter.pullRequests
                     .asObservable()
                     .subscribe(onNext: { [weak self] in
                        self?.tableViewModel?.update(withPullRequests: $0)
                     })
                    .addDisposableTo(disposeBag)
            presenter.currentState
                     .asObservable()
                     .map {
                        [RepositoryDetailState.loading : RepositoryDetailHeaderState.loading,
                        RepositoryDetailState.showingPullRequests : RepositoryDetailHeaderState.loaded,
                        RepositoryDetailState.onError : RepositoryDetailHeaderState.showingRetryOption][$0]
                        ?? RepositoryDetailHeaderState.showingRetryOption
                     }
                    .bind(to: headerView.currentState)
                    .addDisposableTo(disposeBag)
            headerView.currentState
                      .asObservable()
                      .skip(1)
                      .subscribe(onNext: { [weak self] in
                            if $0 == .loading {
                                self?.presenter?.currentState.value = .loading
                            }
                      })
                      .addDisposableTo(disposeBag)
        }
    }
    
    func setupAccessibilityIdentifiers() {
        tableView.accessibilityIdentifier = "PullRequestsTableView"
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "RepositoryDetailShareButton"
    }
    
}
