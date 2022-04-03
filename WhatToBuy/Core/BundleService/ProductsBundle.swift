//
//  LocalProducts.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 25.03.2022.
//

import Foundation

struct ProductCategoriesBundle: Codable {
    var categories: [ProductSectionsBundle]
}

struct ProductSectionsBundle: Codable {
    var name: String
    var items: [String]
}
