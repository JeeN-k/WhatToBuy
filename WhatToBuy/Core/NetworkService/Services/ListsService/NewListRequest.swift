//
//  NewListRequest.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 30.03.2022.
//

import Foundation

struct NewListRequest: DataRequest {
    private let authToken = TokenManager.token ?? ""
    var method: HTTPMethod = .post
    var productList: ProductListRequest
    
    init(productList: ProductList) {
        self.productList = ProductListRequest(name: productList.name, color: productList.color, icon: productList.icon)
    }
    
    typealias Response = NewListResponse
    
    var urlPath: String  = "/productlists/create"
    
    var httpBody: Data? {
        let json = try? JSONEncoder().encode(productList)
        return json
    }
    
    var headers: [String : String] {
        ["auth-token": authToken]
    }
    

}

extension NewListRequest {
    struct ProductListRequest: Encodable {
        var name: String
        var color: String
        var icon: String
    }
}
