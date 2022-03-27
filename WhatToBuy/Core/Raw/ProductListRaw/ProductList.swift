//
//  ProductList.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import Foundation

struct ProductList: Codable {
    var _id: String
    var name: String
    var icon: String
    var color: String
}

extension ProductList {
    init(record: ProductListMO) {
        name = record.name
        icon = record.icon
        color = record.color
        _id = record.id
    }
}
