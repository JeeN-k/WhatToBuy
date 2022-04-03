//
//  EditProductViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 01.04.2022.
//

import Foundation

final class EditProductViewModel {
    let dataProvider: DataProviderProtocol
    var product: Product
    
    var didSentEventClosure: ((EditProductViewModel.Event) -> Void)?
    
    init(dataProvider: DataProviderProtocol, product: Product) {
        self.dataProvider = dataProvider
        self.product = product
    }
    
    func updateProduct() {
        dataProvider.updateProduct(product: product) { [weak self] in
            self?.didSentEventClosure?(.updateProduct)
        }
    }
    
    func cancelUpdate() {
        didSentEventClosure?(.cancel)
    }
    
    func viewModelForCell() -> EditProductCellViewModel {
        return EditProductCellViewModel(product: product)
    }
}

extension EditProductViewModel: ProductPropertiesDelegate {
    func propertyEdited(with value: String?, type: EditProductCellType) {
        switch type {
        case .count:
            product.count = Int(value ?? "0")
        case .price:
            product.price = Float(value ?? "0")
        case .note:
            product.note = value
        }
    }
}

extension EditProductViewModel: HeaderEditedDelegate {
    func productNameEdited(name: String?) {
        guard let name = name else { return }
        product.name = name
    }
}

extension EditProductViewModel {
    enum Event {
        case updateProduct
        case cancel
    }
}
