//
//  FetchProductsRequest.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 30.03.2022.
//

import Foundation

struct FetchProductsRequest: DataRequest {
    typealias Response = ProductResponse
    private let authToken = TokenManager.token ?? ""
    let listId: String
    
    init(listId: String) {
        self.listId = listId
    }
    
    var urlPath: String {
        return "/products/bylist"
    }
    
    var queryItems: [String : String] {
        ["listId": listId]
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String : String] {
        ["auth-token": authToken]
    }
}
