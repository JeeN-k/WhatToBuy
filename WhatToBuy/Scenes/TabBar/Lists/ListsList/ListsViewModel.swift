//
//  ListsViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import Foundation

final class ListsViewModel {
    weak var coordinator: ListsCoordinatorProtocol?
    var didSentEventClosure: ((ListsViewModel.Event) -> Void)?
    var dataProvider: DataProviderProtocol = DataProvider()
    var productLists: [ProductList] = []
    
    func addNewList() {
        didSentEventClosure?(.addList)
    }
    
    func fetchLists(_ completion: @escaping(() -> Void)) {
        dataProvider.fetchLists { [weak self] lists in
            guard let self = self,
                    let lists = lists else { return }
            self.productLists = lists
            completion()
        }
    }
    
    func viewModelForCell(indexPath: IndexPath) -> ListCellViewModel {
        return ListCellViewModel(productList: productLists[indexPath.row])
    }
}

extension ListsViewModel {
    enum Event {
        case addList
    }
}
