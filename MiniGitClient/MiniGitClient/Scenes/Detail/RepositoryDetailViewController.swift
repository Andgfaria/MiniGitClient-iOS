//
//  RepositoryDetailViewController.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 15/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit
import RxSwift

protocol RepositoryDetailPresenterType : class, UITableViewDataSource {
    var currentState : Variable<RepositoryDetailState> { get set }
    weak var viewController : RepositoryDetailViewController? { get set }
    func configureHeader(_ header : RepositoryDetailHeaderView)
    func registerTableView(_ tableView : UITableView)
    var shareItems : [Any] { get }
}

class RepositoryDetailViewController: UIViewController {

    weak var presenter : RepositoryDetailPresenterType?
    
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    let headerView = RepositoryDetailHeaderView()
    
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.registerTableView(tableView)
        addShareButton()
        setup(withViews: [tableView])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupHeader()
    }

}

extension RepositoryDetailViewController {
    
    fileprivate func setupHeader() {
        presenter?.configureHeader(headerView)
        headerView.adjustLayout(withWidth: tableView.bounds.size.width)
        view.layoutIfNeeded()
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: headerView.intrinsicContentSize.height)
        tableView.tableHeaderView = headerView
    }
    
    func show(pullRequests : [PullRequest]) {
        tableView.reloadData()
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
//        headerView.currentState
//                  .asObservable()
//                  .subscribe(onNext: { [weak self] state in
//                    if state == .loading {
//                        self?.presenter?.loadPullRequests()
//                    }
//                    else if state == .loaded {
//                        self?.tableView.reloadData()
//                        self?.setupHeader()
//                    }
//                  })
//                  .addDisposableTo(disposeBag)
        
    }
    
    func setupAccessibilityIdentifiers() {
        tableView.accessibilityIdentifier = "PullRequestsTableView"
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "RepositoryDetailShareButton"
    }
    
}
