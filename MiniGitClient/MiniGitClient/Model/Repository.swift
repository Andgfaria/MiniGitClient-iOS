/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import Foundation

struct Repository  {

    var name = ""
    
    var info = ""
    
    var starsCount = 0
    
    var forksCount = 0
    
    var user : User?
    
    var url : URL?
    
    init() { }
    
    init(json : DataDict) {
        self.name = json["name"] as? String ?? ""
        self.info = json["description"] as? String ?? ""
        self.starsCount = json["stargazers_count"] as? Int ?? 0
        self.forksCount = json["forks_count"] as? Int ?? 0
        if let owner = json["owner"] as? DataDict {
            self.user = User(json: owner)
        }
        if let url = json["url"] as? String {
            self.url = URL(string: url)
        }
    }
    
    fileprivate var textRepresentation : String {
        return "Name: \(name)\n" +
               "Description: \(info)\n" +
               "Stars Count: \(starsCount)\n"  +
               "Forks Count: \(forksCount)\n"  +
               "URL: \(String(describing: url))\n" +
               "Owner : \(String(describing: user))"
    }
    
}

extension Repository : Equatable {
    
    static func == (lhs : Repository, rhs : Repository) -> Bool {
        return lhs.name == rhs.name &&
               lhs.info == rhs.info &&
               lhs.starsCount == rhs.starsCount &&
               lhs.forksCount == rhs.forksCount &&
               lhs.url == rhs.url &&
               lhs.user == rhs.user
    }
    
}

extension Repository : CustomStringConvertible {

    var description : String {
        return textRepresentation
    }
    
}

extension Repository : CustomDebugStringConvertible {
    
    var debugDescription : String {
        return textRepresentation
    }
    
}
