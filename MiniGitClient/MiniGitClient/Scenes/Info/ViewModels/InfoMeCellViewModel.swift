/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import UIKit

struct InfoMeCellViewModel {
    
    private init() { }
    
    static func configureCell(_ cell : UITableViewCell) {
        cell.imageView?.image = R.image.me()
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.layer.masksToBounds = true
        cell.imageView?.layer.cornerRadius = 22
        cell.imageView?.frame = CGRect(x: 10, y: 10, width: 5, height: 5)
        cell.textLabel?.text = R.string.info.me()
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        cell.selectionStyle = .none
    }
    
}
