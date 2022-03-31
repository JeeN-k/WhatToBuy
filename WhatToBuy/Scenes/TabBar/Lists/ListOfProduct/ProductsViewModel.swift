//
//  ProductsViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 27.03.2022.
//

import Foundation

struct ProductSection {
    var name: String
    var products: [Product]
}

protocol ProductsViewModelProtocol {
    var productSection: [ProductSection] { get set }
    func fetchProducts(completion: @escaping(() -> Void))
    func titleForView() -> String
    func openNewProductFlow()
    func viewModelForCell(at indexPath: IndexPath) -> ProductCellViewModel
    func deleteProduct(at indexPath: IndexPath)
}

final class ProductsViewModel: ProductsViewModelProtocol {
    private let dataProvider: DataProviderProtocol
    private var productList: ProductList
    private var products: [Product] = []
    var productSection: [ProductSection] = []
    var didSentEventClosure: ((ProductsViewModel.Event) -> Void)?
    
    init(dataProvider: DataProviderProtocol, productList: ProductList) {
        self.dataProvider = dataProvider
        self.productList = productList
    }
    
    func fetchProducts(completion: @escaping(() -> Void)) {
        dataProvider.fetchProduts(productListID: productList._id) { [weak self] products in
            guard let self = self, let products = products else { return }
            self.products = products
            self.productSection = self.productsToSections(products: products)
            completion()
        }
    }
    
    func deleteProduct(at indexPath: IndexPath) {
        let productId = productSection[indexPath.section].products[indexPath.row]._id
        dataProvider.deleteProduct(productId: productId)
    }
    
    private func productsToSections(products: [Product]) -> [ProductSection] {
        let sections: Set<String> = Set(products.map { $0.category })
        let groupedProducts = sections.map { sect in  ProductSection(name: sect, products: products.filter { $0.category == sect  }) }
        let sortedGroups = groupedProducts.sorted { $0.name < $1.name }
        return sortedGroups
    }
    
    func openNewProductFlow() {
        didSentEventClosure?(.addProduct(products, productList._id))
    }
    
    func titleForView() -> String {
        return productList.name
    }
    
    func viewModelForCell(at indexPath: IndexPath) -> ProductCellViewModel {
        let product = productSection[indexPath.section].products[indexPath.row]
        return ProductCellViewModel(product: product)
    }
}

extension ProductsViewModel {
    enum Event {
        case addProduct([Product], String)
    }
}
