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
    func productTouched(at indexPath: IndexPath)
    var products: Observable<[Product]> { get }
}

final class NewProductViewModel: NewProductViewModelProtocol {
    weak var coordinator: NewProductCoordinator?
    let dataProvider: DataProviderProtocol
    var productCategory: ProductCategoryBundle
    var products: Observable<[Product]> = Observable([])
    var productListId: String
    
    init(dataProvider: DataProviderProtocol, productCategory: ProductCategoryBundle, products: [Product], productListId: String) {
        self.dataProvider = dataProvider
        self.productCategory = productCategory
        self.products.value = products
        self.productListId = productListId
    }
    
    func titleForView() -> String {
        return productCategory.name
    }
    
    func viewModelForCell(at indexPath: IndexPath) -> NewProductCellViewModel {
        let product = productCategory.sections[indexPath.section].items[indexPath.row]
        let isContains = products.value.contains(where: { $0.name == product })
        return NewProductCellViewModel(isAdded: isContains, name: product)
    }
    
    func productTouched(at indexPath: IndexPath) {
        let productName = productCategory.sections[indexPath.section].items[indexPath.row]
        let isContains = products.value.contains(where: { $0.name == productName })
        if !isContains {
            let product = Product(name: productName,
                                  category: productCategory.name,
                                  isBought: false,
                                  _id: UUID().uuidString)
            saveNewProduct(product: product, listId: productListId)
        }
    }
    
    private func saveNewProduct(product: Product, listId: String) {
        products.value.append(product)
        coordinator?.products = self.products.value
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.dataProvider.addProductToList(product: product, productListID: listId)
        }
    }
}
