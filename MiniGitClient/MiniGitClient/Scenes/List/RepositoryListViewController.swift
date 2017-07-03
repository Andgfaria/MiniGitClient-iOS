//
//  RepositoryListViewController.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 30/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum RepositoryListState {
    case loading, showingRepositories, notShowingRepositories
}

protocol RepositoryListPresenterProtocol : class, UITableViewDataSource {
    weak var viewController : RepositoryListViewController? { get set }
    func loadRepositories()
    func registerTableView(_ tableView : UITableView)
}

class RepositoryListViewController: UIViewController {
    
    weak var presenter : RepositoryListPresenterProtocol?

    var currentState = Variable(RepositoryListState.loading)
    
    fileprivate var emptyView = EmptyView()
    
    fileprivate var tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    fileprivate var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.registerTableView(tableView)
        presenter?.loadRepositories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


extension RepositoryListViewController : ViewCodable {
    
    fileprivate func setup() {
        addViewsToHierarchy([emptyView,tableView])
        setupConstraints()
        setupStyles()
        bindComponents()
    }
    

    func setupConstraints() {
        emptyView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        emptyView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        emptyView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        emptyView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func setupStyles() {
        self.view.backgroundColor = .white
        emptyView.isHidden = true
        tableView.estimatedRowHeight = 108
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
    }
    
    func bindComponents() {
        currentState.asObservable().subscribe(onNext: { [weak self] in
            if $0 == .loading {
                self?.presenter?.loadRepositories()
            }
            else if $0 == .showingRepositories {
                self?.tableView.reloadData()
            }
        }).addDisposableTo(disposeBag)
        currentState.asObservable().map { $0 == .notShowingRepositories ? EmptyViewState.showingError : EmptyViewState.loading }.bind(to: emptyView.currentState).addDisposableTo(disposeBag)
        currentState.asObservable().map { $0 == .showingRepositories }.bind(to: emptyView.rx.isHidden).addDisposableTo(disposeBag)
        currentState.asObservable().map { $0 != .showingRepositories }.bind(to: tableView.rx.isHidden).addDisposableTo(disposeBag)
    }
    
}

