//
//  RepositoryDetailViewController.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 15/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit
import RxSwift

protocol RepositoryDetailPresenterProtocol : class, UITableViewDataSource {
    weak var viewController : RepositoryDetailViewController? { get set }
    func configureHeader(_ header : RepositoryDetailHeaderView)
    func registerTableView(_ tableView : UITableView)
    func loadPullRequests()
}

class RepositoryDetailViewController: UIViewController {

    weak var presenter : RepositoryDetailPresenterProtocol?
    
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

extension RepositoryDetailViewController : ViewCodable {
    
    fileprivate func setup() {
        addViewsToHierarchy([tableView])
        setupConstraints()
        setupStyles()
        bindComponents()
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
                  })
                  .addDisposableTo(disposeBag)
        
    }
    
}
