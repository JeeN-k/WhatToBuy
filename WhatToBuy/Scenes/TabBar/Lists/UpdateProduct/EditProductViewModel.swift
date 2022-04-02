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
        dataProvider.updateProduct(product: product)
        didSentEventClosure?(.updateProduct)
    }
    
    func cancelUpdate() {
        didSentEventClosure?(.cancel)
    }
    
    func viewModelForCell() -> EditProductCellViewModel {
        return EditProductCellViewModel(product: product)
    }
}

extension EditProductViewModel {
    enum Event {
        case updateProduct
        case cancel
    }
}
