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
    
    var date : Date?
    
    var user : RepositoryOwner?
    
    init() { }
    
    init(json : DataDict) {
        self.title = json["title"] as? String ?? ""
        self.body = json["body"] as? String ?? ""
        if let date = json["created_at"] as? String {
            let dateFormatter = ISO8601DateFormatter()
            self.date = dateFormatter.date(from: date)
        }
        if let user = json["user"] as? DataDict {
            self.user = RepositoryOwner(json: user)
        }
    }
    
    fileprivate var textRepresentation : String {
        return "Title: \(title)\n" +
               "Body: \(body)\n" +
               "Date: \(String(describing: date))\n" +
               "User: \(String(describing: user))\n"
    }
    
}

extension PullRequest : Equatable {
    
    static func == (lhs : PullRequest, rhs : PullRequest) -> Bool {
        return lhs.title == rhs.title &&
               lhs.body == rhs.body &&
               lhs.date == rhs.date &&
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
