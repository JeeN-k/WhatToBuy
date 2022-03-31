//
//  ProductList.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import Foundation

struct ProductListResponse: Codable {
    var success: Bool
    var data: [ProductList]
}
