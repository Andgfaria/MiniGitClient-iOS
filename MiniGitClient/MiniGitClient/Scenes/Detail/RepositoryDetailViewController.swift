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
    weak var viewController : RepositoryDetailViewController? { get set }
    func configureHeader(_ header : RepositoryDetailHeaderView)
    func registerTableView(_ tableView : UITableView)
    func loadPullRequests()
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
        setup()
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
    
}

extension RepositoryDetailViewController {
    
    fileprivate func addShareButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.share(sender:)))
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
    
    fileprivate func setup() {
        addViewsToHierarchy([tableView])
        setupConstraints()
        setupStyles()
        bindComponents()
        addShareButton()
    }
    
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
        headerView.currentState
                  .asObservable()
                  .subscribe(onNext: { [weak self] state in
                    if state == .loading {
                        self?.presenter?.loadPullRequests()
                    }
                    else if state == .loaded {
                        self?.tableView.reloadData()
                        self?.setupHeader()
                    }
                  })
                  .addDisposableTo(disposeBag)
        
    }
    
}
