//
//  DataRequest.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import Foundation

protocol Responsable {
    associatedtype Response
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol DataRequest:Responsable {
    
    var baseUrl: String { get }
    var urlPath: String { get }
    var method: HTTPMethod { get }
    var headers: [String : String] { get }
    var queryItems: [String : String] { get }
    var httpBody: Data? { get }
    
    func decode(_ data: Data) throws -> Response
}

extension DataRequest where Response: Decodable {
    func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}

extension DataRequest {
    
    var baseUrl: String {
        return "https://digitalleagueapp.ru/api"
    }
    
    var headers: [String : String] {
        [:]
    }
    
    var queryItems: [String : String] {
        [:]
    }
    
    var httpBody: Data? {
        return nil
    }
}
