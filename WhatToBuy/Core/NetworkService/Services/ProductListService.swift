//
//  ProductListService.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import Foundation

struct ProductListService: DataRequest {
    var method: HTTPMethod {
        .get
    }
    typealias Response = [ProductList]
    
    
    var url: String {
        return ""
    }
}
