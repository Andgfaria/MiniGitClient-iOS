/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

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
