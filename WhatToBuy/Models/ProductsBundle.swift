//
//  LocalProducts.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 25.03.2022.
//

import Foundation

struct ProductSectionsBundle: Codable {
    var sections: [ProductSectionBundle]
}

struct ProductSectionBundle: Codable {
    var name: String
    var categories: [ProductCategoriesBundle]
}

struct ProductCategoriesBundle: Codable {
    var name: String
    var items: [String]
}
