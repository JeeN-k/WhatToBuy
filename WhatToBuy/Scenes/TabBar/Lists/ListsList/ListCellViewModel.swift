//
//  ListCellViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import Foundation

final class ListCellViewModel {
    var name: String
    var icon: String
    var color: String
    
    init(productList: ProductList) {
        self.name = productList.name
        self.icon = productList.icon
        self.color = productList.color
    }
}
