//
//  TrashViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 31.03.2022.
//

import Foundation

final class TrashViewModel {
    let dataProvider: DataProviderProtocol
    var productLists: [ProductList] = []
    
    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }
    
    func fetchRemovedLists(completion: @escaping () -> Void) {
        dataProvider.fetchRemovedProductLists { removedLists in
            guard let removedLists = removedLists else { return }
            self.productLists = removedLists
            completion()
        }
    }
    
    func viewModelForCell(at indexPath: IndexPath) -> ListCellViewModel {
        let productList = productLists[indexPath.row]
        return ListCellViewModel(productList: productList)
    }
}
