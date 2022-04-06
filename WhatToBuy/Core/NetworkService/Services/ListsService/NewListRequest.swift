//
//  NewListRequest.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 30.03.2022.
//

import Foundation

struct NewListRequest: DataRequest {
    private let authToken = AccountManager.authToken ?? ""
    var method: HTTPMethod = .post
    var productList: ProductListRequestBody
    
    init(productList: ProductList) {
        self.productList = ProductListRequestBody(name: productList.name, color: productList.color, icon: productList.icon)
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
