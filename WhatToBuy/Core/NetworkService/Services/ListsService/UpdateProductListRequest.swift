//
//  UpdateProductListRequest.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 01.04.2022.
//

import Foundation

struct UpdateProductListRequest: DataRequest {
    typealias Response = BasicResponse
    let authToken = TokenManager.token ?? ""
    let productListID: String
    var productList: ProductListRequestBody
    
    init(productList: ProductList, productListID: String) {
        self.productListID = productListID
        self.productList = ProductListRequestBody(name: productList.name, color: productList.color, icon: productList.icon)
    }
    
    var urlPath: String {
        "/productlists/update/\(productListID)"
    }
    
    var httpBody: Data? {
        let json = try? JSONEncoder().encode(productList)
        return json
    }
    
    var headers: [String : String] {
        ["auth-token": authToken]
    }
    
    var method: HTTPMethod {
        .patch
    }
    
    
}
