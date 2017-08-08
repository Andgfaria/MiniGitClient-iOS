//
//  InfoSceneDeclarations.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 07/08/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import UIKit

protocol InfoPresenterType : class, TableViewSelectionHandler { }

protocol InfoTableViewModelType : TableViewModel, UITableViewDelegate {
    
    weak var selectionHandler : TableViewSelectionHandler? { get set }
    
}

protocol InfoRouterType : class {
    func openGitHubPage()
    func openMailCompose()
}

