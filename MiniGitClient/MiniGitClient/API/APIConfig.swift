//
//  APIConfig.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 20/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Foundation

enum Endpoint : String {
    case search = "SEARCH"
    case pullRequests = "PULLREQUESTS"
}

protocol APIConfig {
    func urlString(with endPoint : Endpoint) -> String?
}

struct MainAPIConfig : APIConfig {
    
    static let shared = MainAPIConfig()
    
    private var baseURL : String?
    
    private var endpointStrings : [String : String]?
    
    private init() {
        if let endpointsFilePath = Bundle.main.path(forResource: "APIEndpoints", ofType: "plist"), let configDict = NSDictionary(contentsOfFile: endpointsFilePath) {
            baseURL = configDict["BASE_URL"] as? String
            endpointStrings = configDict["ENDPOINTS"] as? [String : String]
        }
    }
    
    func urlString(with endPoint : Endpoint) -> String? {
        if let baseURL = baseURL, let endpoints = endpointStrings, let endpointURL = endpoints[endPoint.rawValue] {
            return baseURL + endpointURL
        }
        return nil
    }
    
}
