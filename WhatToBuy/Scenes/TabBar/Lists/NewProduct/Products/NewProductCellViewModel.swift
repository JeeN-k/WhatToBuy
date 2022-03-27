//
//  NewProductCellViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 27.03.2022.
//

import Foundation

final class NewProductCellViewModel {
    let isAdded: Bool
    let name: String
    
    init(isAdded: Bool, name: String) {
        self.isAdded = isAdded
        self.name = name
    }
}
