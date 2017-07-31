//
//  UITestHelper.swift
//  MiniGitClient
//
//  Created by Andre Faria on 31/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import XCTest

struct UITestHelper {
    
    private init() { }
    
    static func scroll(onElement scrollElement : XCUIElement, withScrollDirection scrollDirection: UIAccessibilityScrollDirection, times : Int, andStopClosure stopClosure: ((Void) -> Bool)?) {
        for _ in 0..<times {
            if stopClosure?() ?? false {
                break
            }
            switch scrollDirection {
            case .up:
                scrollElement.swipeUp()
            case .down:
                scrollElement.swipeDown()
            case .left:
                scrollElement.swipeLeft()
            case .right:
                scrollElement.swipeRight()
            default:
                break
            }
        }
    }
    
    
}
