/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import UIKit
import RxSwift
import RxCocoa

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
            presenter.currentState
                     .asObservable()
                     .subscribe(onNext: { [weak self] in
                        if $0 == .showingRepositories {
                            self?.loadMoreview.currentState.value = .normal
                        }
                     }).addDisposableTo(disposeBag)
            presenter.currentState
                     .asObservable()
                     .map { $0 == .showingError ? EmptyViewState.showingError : EmptyViewState.loading }
                     .bind(to: emptyView.currentState)
                     .addDisposableTo(disposeBag)
            presenter.currentState
                     .asObservable()
                     .map { $0 == .showingRepositories || $0 == .loadingMore }
                     .bind(to: emptyView.rx.isHidden)
                     .addDisposableTo(disposeBag)
            presenter.currentState
                     .asObservable()
                     .map { $0 == .loadingFirst || $0 == .showingError }
                     .bind(to: tableView.rx.isHidden)
                     .addDisposableTo(disposeBag)
            infoButton.rx
                      .tap
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

