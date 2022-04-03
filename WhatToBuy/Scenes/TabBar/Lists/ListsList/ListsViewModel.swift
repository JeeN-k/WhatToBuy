//
//  ListsViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import Foundation

protocol ListsViewModelProtocol {
    var productLists: [ProductList] { get }
    func addNewList()
    func fetchLists(_ completion: @escaping(() -> Void))
    func viewModelForCell(indexPath: IndexPath) -> ListCellViewModel
    func selectProductList(indexPath: IndexPath)
    func removeProductListAt(_ indexPath: IndexPath)
    func showInvitesFlow()
}

final class ListsViewModel: ListsViewModelProtocol {
    var dataProvider: DataProviderProtocol
    var didSentEventClosure: ((ListsViewModel.Event) -> Void)?
    var productLists: [ProductList] = []
    
    init(dataProvider: DataProviderProtocol) {
        self.dataProvider = dataProvider
    }
    
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
    
    func removeProductListAt(_ indexPath: IndexPath) {
        let productListID = productLists[indexPath.row]._id
        productLists.remove(at: indexPath.row)
        dataProvider.removeToTrashProductList(productListID: productListID)
    }
    
    func selectProductList(indexPath: IndexPath) {
        let productList = productLists[indexPath.row]
        didSentEventClosure?(.selectProductList(list: productList))
    }
    
    func viewModelForCell(indexPath: IndexPath) -> ListCellViewModel {
        return ListCellViewModel(productList: productLists[indexPath.row])
    }
    
    func showInvitesFlow() {
        didSentEventClosure?(.invites)
    }
}

extension ListsViewModel {
    enum Event {
        case addList
        case selectProductList(list: ProductList)
        case invites
    }
}
