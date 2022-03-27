//
//  Product.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 27.03.2022.
//

import Foundation

struct Product: Codable {
    var name: String
    var count: Int?
    var price: Float?
    var category: String?
}

extension Product {
    init(record: ProductMO) {
        name = record.name
        count = Int(record.count)
        price = record.price
        category = record.category
    }
}
