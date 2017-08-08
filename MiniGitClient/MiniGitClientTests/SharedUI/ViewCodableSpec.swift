//
//  ViewCodableSpec.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 26/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Quick
import Nimble
@testable import MiniGitClient

class MockedCodedView : UIView, ViewCodable {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    required init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    private func setup() {
        let firstView = UIView(frame: CGRect.zero)
        let secondView = UIView(frame: CGRect.zero)
        addViewsToHierarchy([firstView,secondView])
    }
    
}

private class MockedCodedViewController : UIViewController, ViewCodable {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    required init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    private func setup() {
        let firstView = UIView(frame: CGRect.zero)
        let secondView = UIView(frame: CGRect.zero)
        addViewsToHierarchy([firstView,secondView])
    }
    
}

class ViewCodableSpec: QuickSpec {
    
    override func spec() {
        
        describe("The ViewCodable protocol") { 
            
            context("by default", { 
                
                it("can add views to itself when it is an UIView") {
                    let mockedView = MockedCodedView()
                    expect(mockedView.subviews.count) == 2
                    mockedView.subviews.forEach {
                        expect($0.translatesAutoresizingMaskIntoConstraints).to(beFalse())
                    }
                }
                
                it("can add views to the main controller view when it is an UIViewController") {
                    let mockedViewController = MockedCodedViewController()
                    expect(mockedViewController.view.subviews.count) == 2
                    mockedViewController.view.subviews.forEach {
                        expect($0.translatesAutoresizingMaskIntoConstraints).to(beFalse())
                    }
                }
                
            })
            
        }
        
    }
    
}
