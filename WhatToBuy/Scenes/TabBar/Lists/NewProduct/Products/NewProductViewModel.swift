//
//  NewProductViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 27.03.2022.
//

import Foundation

protocol NewProductViewModelProtocol {
    var products: Observable<[Product]> { get }
    var productCategory: ProductSectionsBundle { get }
    func titleForView() -> String
    func viewModelForCell(at indexPath: IndexPath) -> NewProductCellViewModel
    func productTouched(at indexPath: IndexPath)
}

final class NewProductViewModel: NewProductViewModelProtocol {
    weak var coordinator: NewProductCoordinator?
    let dataProvider: DataProviderProtocol
    var productCategory: ProductSectionsBundle
    var products: Observable<[Product]> = Observable([])
    private var productListId: String
    
    init(dataProvider: DataProviderProtocol, productCategory: ProductSectionsBundle, products: [Product], productListId: String) {
        self.dataProvider = dataProvider
        self.productCategory = productCategory
        self.products.value = products
        self.productListId = productListId
    }
    
    func titleForView() -> String {
        return productCategory.name
    }
    
    func viewModelForCell(at indexPath: IndexPath) -> NewProductCellViewModel {
        let product = productCategory.items[indexPath.row]
        let isContains = products.value.contains(where: { $0.name == product })
        return NewProductCellViewModel(isAdded: isContains, name: product)
    }
    
    func productTouched(at indexPath: IndexPath) {
        let productName = productCategory.items[indexPath.row]
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
