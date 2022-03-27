//
//  NewProductsCategoriesViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 27.03.2022.
//

import Foundation

protocol NewProductsCategoriesViewModelProtocol {
    var productCategories: [ProductCategoryBundle] { get set }
    func fetchProductCategories(_ completion: @escaping(() -> Void))
    func categorySelected(at indexPath: IndexPath)
}

final class NewProductsCategoriesViewModel: NewProductsCategoriesViewModelProtocol {
    
    let dataProvider: DataProviderProtocol
    var didSentEventClosure: ((NewProductsCategoriesViewModel.Event) -> Void)?
    var productCategories: [ProductCategoryBundle] = []
    var products: [Product]
    
    init(dataProvider: DataProviderProtocol, products: [Product]) {
        self.dataProvider = dataProvider
        self.products = products
    }
    
    func fetchProductCategories(_ completion: @escaping(() -> Void)) {
        dataProvider.fetchLocalProducts { products in
            guard let products = products else { return }
            self.productCategories = products.categories
            completion()
        }
    }
    
    func categorySelected(at indexPath: IndexPath) {
        let selectedCategory = productCategories[indexPath.row]
        didSentEventClosure?(.selectCategory(selectedCategory, products))
    }
}

extension NewProductsCategoriesViewModel {
    enum Event {
        case selectCategory(ProductCategoryBundle, [Product])
    }
}
