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

protocol RepositoryListPresenterType : class {
    var currentState : Variable<RepositoryListState> { get set }
    var repositories : Variable<[Repository]> { get }
    func onInfoButtonTap()
}

protocol RepositoryListTableViewModelType : TableViewModel, UITableViewDelegate {
    weak var selectionHandler : TableViewSelectionHandler? { get set }
    func updateWith(repositories : [Repository])
    
}

class RepositoryListViewController: UIViewController {
    
    weak var presenter : RepositoryListPresenterType?
    
    weak var tableViewModel : RepositoryListTableViewModelType?
    
    fileprivate var emptyView = EmptyView()
    
    fileprivate var tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    fileprivate var loadMoreview = LoadMoreView()
    
    fileprivate var infoButton = UIButton(type: .infoLight)
    
    fileprivate var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.list.title()
        navigationItem.title = title
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: infoButton)
        setup(withViews: [emptyView,tableView])
        tableViewModel?.register(tableView: tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearSelectionIfNeeded()
    }
    
}


extension RepositoryListViewController {
    
    fileprivate func clearSelectionIfNeeded() {
        if view.traitCollection.horizontalSizeClass == .compact && view.traitCollection.verticalSizeClass == .regular {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: false)
            }
        }
    }
    
}

extension RepositoryListViewController : ViewCodable {
    
    func setupConstraints() {
        emptyView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        emptyView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        emptyView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        emptyView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        loadMoreview.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 72)
        tableView.tableFooterView = loadMoreview
    }
    
    func setupStyles() {
        self.view.backgroundColor = .white

        emptyView.message = R.string.list.errorMesage()
        emptyView.actionTitle = R.string.list.actionTitle()
        
        loadMoreview.loadTitle = R.string.list.loadMoreTitle()
        
        tableView.estimatedRowHeight = 108
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
    }
    
    func bindComponents() {
        if let presenter = presenter {
            emptyView.actionBlock = {
                presenter.currentState.value = .loadingFirst
            }
            loadMoreview.loadingBlock = {
                presenter.currentState.value = .loadingMore
            }
            presenter.repositories
                     .asObservable()
                     .subscribe(onNext: { [weak self] in
                            self?.tableViewModel?.updateWith(repositories: $0)
                     })
                    .addDisposableTo(disposeBag)
            presenter.currentState.asObservable().subscribe(onNext: { [weak self] in
                if $0 == .showingRepositories {
                    self?.loadMoreview.currentState.value = .normal
                }
            }).addDisposableTo(disposeBag)
            presenter.currentState.asObservable()
                .map { $0 == .showingError ? EmptyViewState.showingError : EmptyViewState.loading }
                .bind(to: emptyView.currentState)
                .addDisposableTo(disposeBag)
            presenter.currentState.asObservable()
                .map { $0 == .showingRepositories || $0 == .loadingMore }
                .bind(to: emptyView.rx.isHidden)
                .addDisposableTo(disposeBag)
            presenter.currentState.asObservable()
                .map { $0 == .loadingFirst || $0 == .showingError }
                .bind(to: tableView.rx.isHidden)
                .addDisposableTo(disposeBag)
            infoButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    self?.presenter?.onInfoButtonTap()
                })
                .addDisposableTo(disposeBag)
        }

    }
    
    func setupAccessibilityIdentifiers() {
        tableView.accessibilityIdentifier = "RepositoriesListTableView"
        navigationItem.leftBarButtonItem?.accessibilityIdentifier = "InfoButton"
    }
    
}

