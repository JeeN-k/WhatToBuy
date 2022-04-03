//
//  EditProductCellViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 01.04.2022.
//

import Foundation

protocol HeaderEditedDelegate {
    func productNameEdited(name: String?)
}

protocol ProductPropertiesDelegate {
    func propertyEdited(with data: String?, type: EditProductCellType)
}

final class EditProductCellViewModel {
    let product: Product
    
    var headerDelegate: HeaderEditedDelegate?
    var propertyDelegate: ProductPropertiesDelegate?
    
    init(product: Product) {
        self.product = product
    }
    
    func titleChanged(with text: String?) {
        guard let headerDelegate = headerDelegate else { return }
        headerDelegate.productNameEdited(name: text)
    }
    
    func properyChanged(with value: String?, type: EditProductCellType) {
        guard let propertyDelegate = propertyDelegate else { return }
        propertyDelegate.propertyEdited(with: value, type: type)
    }
}

