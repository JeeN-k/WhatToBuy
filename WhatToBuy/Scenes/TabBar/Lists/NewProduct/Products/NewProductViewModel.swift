//
//  NewProductViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 27.03.2022.
//

import Foundation

protocol NewProductViewModelProtocol {
    var productCategory: ProductCategoryBundle { get }
    func titleForView() -> String
    func viewModelForCell(at indexPath: IndexPath) -> NewProductCellViewModel
}

final class NewProductViewModel: NewProductViewModelProtocol {
    
    let dataProvider: DataProviderProtocol
    var productCategory: ProductCategoryBundle
    
    init(dataProvider: DataProviderProtocol, productCategory: ProductCategoryBundle) {
        self.dataProvider = dataProvider
        self.productCategory = productCategory
    }
    
    func titleForView() -> String {
        return productCategory.name
    }
    
    func viewModelForCell(at indexPath: IndexPath) -> NewProductCellViewModel {
        let product = productCategory.sections[indexPath.section].items[indexPath.row]
        return NewProductCellViewModel(isAdded: false, name: product)
    }
    
    func addProduct() {
        
    }
}
