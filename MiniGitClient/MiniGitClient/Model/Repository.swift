//
//  Repository.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 20/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Foundation

struct Repository  {

    var name = ""
    
    var info = ""
    
    var starsCount = 0
    
    var forksCount = 0
    
    init() { }
    
    init(json : [String : Any]) {
        self.name = json["name"] as? String ?? ""
        self.info = json["description"] as? String ?? ""
        self.starsCount = json["stargazers_count"] as? Int ?? 0
        self.forksCount = json["forks_count"] as? Int ?? 0
    }
    
    fileprivate var textRepresentation : String {
        return "Name: \(name)\n" +
               "Description: \(info)\n" +
               "Stars Count: \(starsCount)\n"  +
               "Forks Count: \(forksCount)\n"
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
