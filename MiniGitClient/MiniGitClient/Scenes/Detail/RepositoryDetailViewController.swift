//
//  RepositoryDetailViewController.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 15/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit
import RxSwift

protocol RepositoryDetailPresenterType : class {
    var currentState : Variable<RepositoryDetailState> { get set }
    var repository : Repository { get }
    weak var viewController : RepositoryDetailViewController? { get set }
    var shareItems : [Any] { get }
}

protocol RepositoryDetailTableViewModelType : class, TableViewModel {
    var selectionHandler : TableViewSelectionHandler? { get set }
    func update(withPullRequests pullRequests : [PullRequest])
}

class RepositoryDetailViewController: UIViewController {

    weak var presenter : RepositoryDetailPresenterType?
    
    weak var tableViewModel : RepositoryDetailTableViewModelType?
    
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    let headerView = RepositoryDetailHeaderView()
    
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let presenter = presenter {
            RepositoryDetailHeaderViewModel.configureHeader(headerView, withRepository: presenter.repository)
        }
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
    
    func show(pullRequests : [PullRequest]) {
        tableViewModel?.update(withPullRequests: pullRequests)
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
            presenter.currentState.asObservable()
                .map { [RepositoryDetailState.loading : RepositoryDetailHeaderState.loading,
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
