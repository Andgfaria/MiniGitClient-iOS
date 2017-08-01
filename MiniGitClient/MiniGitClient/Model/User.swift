//
//  User.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 20/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Foundation

struct User {
    
    var name = ""
    
    var avatarURL : URL?
    
    init() { }
    
    init(json : DataDict) {
        self.name = json["login"] as? String ?? ""
        if let urlString = json["avatar_url"] as? String {
            self.avatarURL = URL(string: urlString)
        }
    }
    
    fileprivate var textRepresentation : String {
        return "Name: \(name)\nAvatar URL: \(String(describing: avatarURL))"
    }
    
}

extension User : Equatable {
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.name == rhs.name && lhs.avatarURL == rhs.avatarURL
    }
    
}

extension User : CustomStringConvertible {
    
    var description : String {
        return textRepresentation
    }
    
}

extension User : CustomDebugStringConvertible {
    
    var debugDescription : String {
        return textRepresentation
    }
    
}
