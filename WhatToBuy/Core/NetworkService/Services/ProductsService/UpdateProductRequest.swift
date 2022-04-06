//
//  UpdateProductRequest.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 01.04.2022.
//

import Foundation

struct UpdateProductRequest: DataRequest {
    let authToken = AccountManager.authToken ?? ""
    typealias Response = BasicResponse
    let product: Product
    let productBody: EditedProductRequestBody
    
    init(product: Product) {
        self.product = product
        productBody = EditedProductRequestBody(name: product.name,
                                         price: product.price,
                                         count: product.count,
                                         category: product.category,
                                         note: product.note)
    }
    
    var httpBody: Data? {
        let json = try? JSONEncoder().encode(productBody)
        return json
    }
    
    var urlPath: String {
        "/products/update/\(product._id)"
    }
    
    var method: HTTPMethod {
        .patch
    }
    
    var headers: [String : String] {
        ["auth-token": authToken]
    }
}
