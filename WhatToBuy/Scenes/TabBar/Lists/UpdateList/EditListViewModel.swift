//
//  EditListViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 01.04.2022.
//

import Foundation

protocol EditListViewModelProtocol: EditableList {
    var productList: ProductList { get }
    func cancelEdit()
    func updateList(name: String?)
}

final class EditListViewModel: EditListViewModelProtocol {
    var pickerSelection: PickerSelection
    let dataProvider: DataProviderProtocol
    let productList: ProductList
    var didSentEventClosure: ((EditListViewModel.Event) -> Void)?
    
    init(dataProvider: DataProvider, productList: ProductList) {
        self.dataProvider = dataProvider
        self.productList = productList
        self.pickerSelection = PickerSelection(icon: productList.icon, color: productList.color)
    }
    
    func cancelEdit() {
        didSentEventClosure?(.cancelEdit)
    }
    
    func updateList(name: String?) {
        guard let name = name else { return }
        let productList = ProductList(_id: productList._id,
                                      name: name,
                                      icon: pickerSelection.icon,
                                      color: pickerSelection.color)
        dataProvider.updateProductList(productList: productList, productListID: productList._id)
        didSentEventClosure?(.updateList)
    }
}

extension EditListViewModel {
    enum Event {
        case cancelEdit
        case updateList
    }
}
