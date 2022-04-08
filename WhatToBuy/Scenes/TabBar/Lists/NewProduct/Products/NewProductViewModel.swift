//
//  NewProductViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 27.03.2022.
//

import Foundation

protocol NewProductViewModelProtocol {
    var products: Observable<[Product]> { get }
    func titleForView() -> String
    func viewModelForCell(at indexPath: IndexPath, isSearching: Bool) -> NewProductCellViewModel
    func productTouched(at indexPath: IndexPath, isSearching: Bool)
    func filterProductsWith(text: String)
    func numberOfRows(isSearching: Bool) -> Int
}

final class NewProductViewModel: NewProductViewModelProtocol {
    weak var coordinator: NewProductCoordinator?
    let dataProvider: DataProviderProtocol
    var productCategory: ProductSectionsBundle
    var products: Observable<[Product]> = Observable([])
    var filteredProducts: [String] = []
    private var productListId: String
    
    init(dataProvider: DataProviderProtocol, productCategory: ProductSectionsBundle, products: [Product], productListId: String) {
        self.dataProvider = dataProvider
        self.productCategory = productCategory
        self.products.value = products
        self.filteredProducts = productCategory.items
        self.productListId = productListId
    }
    
    func titleForView() -> String {
        return productCategory.name
    }
    
    func filterProductsWith(text: String) {
        filteredProducts = productCategory.items.filter({ $0.lowercased().contains(text.lowercased()) })
    }
    
    func numberOfRows(isSearching: Bool) -> Int {
        if isSearching {
            return filteredProducts.count
        } else {
            return productCategory.items.count
        }
    }
    
    func viewModelForCell(at indexPath: IndexPath, isSearching: Bool) -> NewProductCellViewModel {
        let productName = !isSearching ? productCategory.items[indexPath.row] : filteredProducts[indexPath.row]
        let isContains = products.value.contains(where: { $0.name == productName })
        return NewProductCellViewModel(isAdded: isContains, name: productName)
    }
    
    func productTouched(at indexPath: IndexPath, isSearching: Bool) {
        let productName = !isSearching ? productCategory.items[indexPath.row] : filteredProducts[indexPath.row]
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
