//
//  ProductCellViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 28.03.2022.
//

import Foundation

final class ProductCellViewModel {
    var name: String
    var price: Float?
    var count: Int?
    var note: String?
    
    init(product: Product) {
        self.name = product.name
        self.price = product.price
        self.count = product.count
        self.note = product.note
    }
}
