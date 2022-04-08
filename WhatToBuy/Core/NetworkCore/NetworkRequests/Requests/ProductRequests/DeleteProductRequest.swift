//
//  DeleteProductRequest.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 30.03.2022.
//

import Foundation

struct DeleteProductRequest: DataRequest {
    let authToken = AccountManager.authToken ?? ""
    typealias Response = BasicResponse
    var method: HTTPMethod = .delete
    var productId: String
    
    init(productId: String) {
        self.productId = productId
    }
    
    var urlPath: String {
        "/products/\(productId)"
    }
    
    var headers: [String : String] {
        ["auth-token": authToken]
    }
}
