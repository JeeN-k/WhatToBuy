//
//  Product.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 27.03.2022.
//

import Foundation

struct Product: Codable {
    var name: String
    var category: String
    var count: Int?
    var price: Float?
    var note: String?
    var isBought: Bool
    var _id: String
}

extension Product {
    init(record: ProductMO) {
        name = record.name
        count = Int(record.count)
        note = record.note
        price = record.price
        category = record.category
        isBought = record.isBought
        _id = record.id
    }
}
