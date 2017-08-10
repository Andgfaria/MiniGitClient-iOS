/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

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
