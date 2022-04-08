//
//  FetchListsRequest.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 30.03.2022.
//

import Foundation

struct FetchListsRequest: DataRequest {
    typealias Response = ProductListResponse
    private let authToken = AccountManager.authToken ?? ""
    
    var urlPath: String {
        return "/productlists/byuser"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String : String] {
        ["auth-token": authToken]
    }
}
