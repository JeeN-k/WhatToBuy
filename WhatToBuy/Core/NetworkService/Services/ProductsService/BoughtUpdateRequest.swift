//
//  BoughtUpdateRequest.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 03.04.2022.
//

import Foundation

struct BoughtUpdateRequest: DataRequest {
    let authToken = AccountManager.authToken ?? ""
    typealias Response = BasicResponse
    
    let productId: String
    let isBought: Bool
    
    init(productId: String, isBought: Bool) {
        self.productId = productId
        self.isBought = isBought
    }
    
    var method: HTTPMethod {
        .patch
    }
    
    var urlPath: String {
        "/products/bought"
    }
    
    var queryItems: [String : String] {
        ["productId": productId, "isBought": String(isBought)]
    }
    
    var headers: [String : String] {
        ["auth-token": authToken]
    }
}
