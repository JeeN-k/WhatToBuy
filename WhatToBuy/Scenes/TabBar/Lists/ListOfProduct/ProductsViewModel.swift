//
//  ProductsViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 27.03.2022.
//

import Foundation

protocol ProductsViewModelProtocol {
    var products: [Product] { get set }
    func fetchProducts(completion: @escaping(() -> Void))
    func titleForView() -> String
    func addProduct()
}

final class ProductsViewModel: ProductsViewModelProtocol {
    
    let dataProvider: DataProviderProtocol
    var didSentEventClosure: ((ProductsViewModel.Event) -> Void)?
    var productList: ProductList
    var products: [Product] = []
    
    init(dataProvider: DataProviderProtocol, productList: ProductList) {
        self.dataProvider = dataProvider
        self.productList = productList
    }
    
    func fetchProducts(completion: @escaping(() -> Void)) {
        dataProvider.fetchProduts { [weak self] products in
            guard let self = self, let products = products else { return }
            self.products = products
            completion()
        }
    }
    
    func addProduct() {
        didSentEventClosure?(.addProduct(products))
    }
    
    func titleForView() -> String {
        return productList.name
    }
    
}

extension ProductsViewModel {
    enum Event {
        case addProduct([Product])
    }
}
