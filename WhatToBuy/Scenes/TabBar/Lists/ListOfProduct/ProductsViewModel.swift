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
    func fetchProducts(completion: @escaping(() -> Void))
    func titleForView() -> String
    func titleForSection(at section: Int) -> String
    func numberOfRows(at section: Int) -> Int
    func numberOfSections() -> Int
    func removeSection(at section: Int)
    func removeProduct(at indexPath: IndexPath)
    func openNewProductFlow()
    func viewModelForCell(at indexPath: IndexPath) -> ProductCellViewModel
    func deleteProduct(at indexPath: IndexPath)
    func editProductsList()
    func openEditProductFlow(at indexPath: IndexPath)
    func inviteUser(email: String)
    func updateIsBought(at indexPath: IndexPath)
}

final class ProductsViewModel: ProductsViewModelProtocol {
    private let dataProvider: DataProviderProtocol
    private var productList: ProductList
    private var products: [Product] = []
    private var productSection: [ProductSection] = []
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
        let groupedProducts = sections.map { sect in
            ProductSection(name: sect,
                           products: products.filter { $0.category == sect }.sorted { !$0.isBought && $1.isBought }) }
        let sortedGroups = groupedProducts.sorted { $0.name < $1.name }
        return sortedGroups
    }
    
    func openNewProductFlow() {
        didSentEventClosure?(.addProduct(products, productList._id))
    }
    
    func titleForView() -> String {
        return productList.name
    }
    
    func titleForSection(at section: Int) -> String {
        return productSection[section].name
    }
    
    func numberOfRows(at section: Int) -> Int {
        return productSection[section].products.count
    }
    
    func numberOfSections() -> Int {
        return productSection.count
    }
    
    func removeSection(at section: Int) {
        productSection.remove(at: section)
    }
    
    func removeProduct(at indexPath: IndexPath) {
        productSection[indexPath.section].products.remove(at: indexPath.row)
    }
    
    func viewModelForCell(at indexPath: IndexPath) -> ProductCellViewModel {
        let product = productSection[indexPath.section].products[indexPath.row]
        return ProductCellViewModel(product: product)
    }
    
    func editProductsList() {
        didSentEventClosure?(.editList)
    }
    
    func openEditProductFlow(at indexPath: IndexPath) {
        let product = productSection[indexPath.section].products[indexPath.row]
        didSentEventClosure?(.editProduct(product))
    }
    
    func inviteUser(email: String) {
        dataProvider.inviteUserToList(email: email, listId: productList._id)
    }
    
    func updateIsBought(at indexPath: IndexPath) {
        let product = productSection[indexPath.section].products[indexPath.row]
        productSection[indexPath.section].products[indexPath.row].isBought.toggle()
        dataProvider.productIsBoughtUpdate(productId: product._id, isBought: !product.isBought)
        productSection[indexPath.section].products.sort { !$0.isBought && $1.isBought}
    }
}

extension ProductsViewModel {
    enum Event {
        case addProduct([Product], String)
        case editList
        case editProduct(Product)
    }
}
