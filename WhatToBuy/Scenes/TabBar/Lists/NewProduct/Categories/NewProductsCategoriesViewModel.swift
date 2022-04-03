//
//  NewProductsCategoriesViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 27.03.2022.
//

import Foundation

protocol NewProductsCategoriesViewModelProtocol {
    var productCategories: [ProductSectionsBundle] { get set }
    func fetchProductCategories(_ completion: @escaping(() -> Void))
    func categorySelected(at indexPath: IndexPath)
}

final class NewProductsCategoriesViewModel: NewProductsCategoriesViewModelProtocol {
    
    let dataProvider: DataProviderProtocol
    var didSentEventClosure: ((NewProductsCategoriesViewModel.Event) -> Void)?
    var productCategories: [ProductSectionsBundle] = []
    
    init(dataProvider: DataProviderProtocol) {
        self.dataProvider = dataProvider
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
        didSentEventClosure?(.selectCategory(selectedCategory))
    }
}

extension NewProductsCategoriesViewModel {
    enum Event {
        case selectCategory(ProductSectionsBundle)
    }
}
