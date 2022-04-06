//
//  NewProductRequest.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 30.03.2022.
//

import Foundation

struct NewProductRequest: DataRequest {
    private let authToken = AccountManager.authToken ?? ""
    let product: ProductRequest
    let listId: String
    
    init(listId: String, product: Product) {
        self.product = ProductRequest(name: product.name, category: product.category)
        self.listId = listId
    }
    
    typealias Response = NewProductResponse
    
    var urlPath: String  = "/products/create"
    
    var method: HTTPMethod = .post
    var httpBody: Data? {
        let json = try? JSONEncoder().encode(product)
        return json
    }
    
    var queryItems: [String : String] {
        ["listId": listId]
    }
    
    var headers: [String : String] {
        ["auth-token": authToken]
    }
}
