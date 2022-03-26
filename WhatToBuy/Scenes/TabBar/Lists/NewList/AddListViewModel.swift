//
//  AddListViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import Foundation

final class AddListViewModel {
    let dataProvider: DataProviderProtocol = DataProvider()
    weak var coordinator: ListsCoordinator?
    var pickerSelection: PickerSelection = PickerSelection(icon: Icons.allCases[0].rawValue,
                                                           color: Colors.allCases[0].getColorHex())
    var didSentEventClosure: ((AddListViewModel.Event) -> Void)?
    
    func cancelAdding() {
        didSentEventClosure?(.cancel)
    }
    
    func createNewList(name: String?) {
        guard let name = name, name != "" else { return }
        let productList = ProductList(_id: UUID().uuidString, name: name, icon: pickerSelection.icon, color: pickerSelection.color)
        dataProvider.createNewList(productList: productList)
        didSentEventClosure?(.addList)
    }
}

extension AddListViewModel {
    enum Event {
        case addList
        case cancel
    }
}
