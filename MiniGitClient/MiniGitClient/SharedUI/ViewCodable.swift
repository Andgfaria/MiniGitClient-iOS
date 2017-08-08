//
//  ViewCodable.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 25/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Foundation
import UIKit

protocol ViewCodable {
    func setup(withViews views : [UIView])
    func addViewsToHierarchy(_ views : [UIView])
    func setupConstraints()
    func setupStyles()
    func bindComponents()
    func setupAccessibilityIdentifiers()
}

extension ViewCodable {
    
    func setup(withViews views : [UIView]) {
        addViewsToHierarchy(views)
        setupConstraints()
        setupStyles()
        bindComponents()
        setupAccessibilityIdentifiers()
    }
    
    func setupConstraints() { }
    func setupStyles()      { }
    func bindComponents()   { }
    func setupAccessibilityIdentifiers() { }
}

extension ViewCodable where Self : UIView {
    
    func addViewsToHierarchy(_ views : [UIView]) {
        views.forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
}

extension ViewCodable where Self : UIViewController {
    
    func addViewsToHierarchy(_ views : [UIView]) {
        views.forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
}

extension ViewCodable where Self : UITableViewCell {
    
    func addViewsToHierarchy(_ views : [UIView]) {
        views.forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
}
