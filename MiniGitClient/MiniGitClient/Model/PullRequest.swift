//
//  PullRequest.swift
//  MiniGitClient
//
//  Created by Andre Faria on 10/07/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Foundation


struct PullRequest {
    
    var title = ""
    
    var body = ""
    
    var user : RepositoryOwner?
    
    var url : URL?
    
    init() { }
    
    init(json : DataDict) {
        self.title = json["title"] as? String ?? ""
        self.body = json["body"] as? String ?? ""
        if let user = json["user"] as? DataDict {
            self.user = RepositoryOwner(json: user)
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
