//
//  APIUtils.swift
//  MiniGitClient
//
//  Created by André Gimenez Faria on 24/06/17.
//  Copyright © 2017 AGF. All rights reserved.
//

import Foundation

typealias DataDict = [String : Any]

enum RequestResult<T> {
    case success(T)
    case failure(Error)
}

enum APIRequestError : Error {
    case networkError, invalidJson, invalidEndpoint
}
