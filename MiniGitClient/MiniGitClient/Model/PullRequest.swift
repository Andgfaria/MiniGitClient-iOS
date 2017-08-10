/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */
import Foundation


struct PullRequest {
    
    var title = ""
    
    var body = ""
    
    var user : User?
    
    var url : URL?
    
    init() { }
    
    init(json : DataDict) {
        self.title = json["title"] as? String ?? ""
        self.body = json["body"] as? String ?? ""
        if let user = json["user"] as? DataDict {
            self.user = User(json: user)
        }
        if let url = json["url"] as? String {
            self.url = URL(string: url)
        }
    }
    
    fileprivate var textRepresentation : String {
        return "Title: \(title)\n" +
               "Body: \(body)\n" +
               "URL: \(String(describing: url))\n" +
               "User: \(String(describing: user))\n"
    }
    
}

extension PullRequest : Equatable {
    
    static func == (lhs : PullRequest, rhs : PullRequest) -> Bool {
        return lhs.title == rhs.title &&
               lhs.body == rhs.body &&
               lhs.url == rhs.url &&
               lhs.user == rhs.user
    }
    
}

extension PullRequest : CustomStringConvertible {
    
    var description : String {
        return textRepresentation
    }
    
}

extension PullRequest : CustomDebugStringConvertible {
    
    var debugDescription : String {
        return textRepresentation
    }
    
}
