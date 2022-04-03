//
//  TrashViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 31.03.2022.
//

import Foundation

protocol TrashViewModelProtocol {
    func fetchRemovedLists(completion: @escaping () -> Void)
    func deleteList(at indexPath: IndexPath)
    func restoreList(at indexPath: IndexPath)
    func viewModelForCell(at indexPath: IndexPath) -> ListCellViewModel
    func numberOfItems() -> Int
}

final class TrashViewModel: TrashViewModelProtocol {
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
    
    func numberOfItems() -> Int {
        return productLists.count
    }
    
    func deleteList(at indexPath: IndexPath) {
        let list = productLists[indexPath.row]
        dataProvider.deleteProductList(listId: list._id)
        productLists.remove(at: indexPath.row)
    }
    
    func restoreList(at indexPath: IndexPath) {
        let list = productLists[indexPath.row]
        dataProvider.restoreFromTrashProductList(listId: list._id)
        productLists.remove(at: indexPath.row)
    }
    
    func viewModelForCell(at indexPath: IndexPath) -> ListCellViewModel {
        let productList = productLists[indexPath.row]
        return ListCellViewModel(productList: productList)
    }
}
