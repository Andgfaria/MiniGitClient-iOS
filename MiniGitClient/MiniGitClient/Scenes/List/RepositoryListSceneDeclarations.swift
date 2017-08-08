//
//  RepositoryListSceneDeclarations.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 07/08/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit
import RxSwift

protocol RepositoryListPresenterType : class {
    var currentState : Variable<RepositoryListState> { get set }
    var repositories : Variable<[Repository]> { get }
    func onInfoButtonTap()
}

protocol RepositoryListTableViewModelType : TableViewModel, UITableViewDelegate {
    weak var selectionHandler : TableViewSelectionHandler? { get set }
    func updateWith(repositories : [Repository])
    
}

enum RepositoryListState {
    case loadingFirst, showingRepositories, loadingMore, showingError
}

protocol RepositoryListRouterType : class {
    func onRepositorySelection(_ repository : Repository)
    func onInfoScreenRequest()
}

protocol RepositoryListInteractorType : class {
    var repositoriesStore : RepositoriesStoreType { get set }
    func repositories(fromPage page : Int) -> Observable<[Repository]>
}
