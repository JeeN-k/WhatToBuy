//
//  ListsCoordinator.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import UIKit

class ListsCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .tab }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showListsViewController()
    }
    
    private func showListsViewController() {
        let dataProvider: DataProviderProtocol = DataProvider()
        let listsViewModel = ListsViewModel(dataProvider: dataProvider)
        let listsViewController = ListsViewController(viewModel: listsViewModel)
        listsViewModel.didSentEventClosure = { [weak self] event in
            switch event {
            case .addList:
                self?.showNewListViewController()
            case .selectProductList(let list):
                self?.showProductsViewController(productList: list)
            }
        }
        navigationController.pushViewController(listsViewController, animated: true)
    }
    
    func showProductsViewController(productList: ProductList) {
        let dataProvider: DataProviderProtocol = DataProvider()
        let productsViewModel = ProductsViewModel(dataProvider: dataProvider, productList: productList)
        let productsViewController = ProductsViewController(viewModel: productsViewModel)
        productsViewModel.didSentEventClosure = { [weak self] event in
            switch event {
            case .addProduct(let products, let productListId):
                self?.showNewProductFlow(currentProducts: products, productListId: productListId)
            }
        }
        navigationController.pushViewController(productsViewController, animated: true)
    }
    
    func showNewListViewController() {
        let dataProvider: DataProviderProtocol = DataProvider()
        let newListViewModel = AddListViewModel(dataProvider: dataProvider)
        let newListViewController = AddListViewController(viewModel: newListViewModel)
        newListViewModel.didSentEventClosure = { [weak self] event in
            switch event {
            case .addList:
                self?.navigationController.popViewController(animated: true)
            case .cancel:
                self?.navigationController.popViewController(animated: true)
            }
        }
        newListViewController.viewModel = newListViewModel
        navigationController.pushViewController(newListViewController, animated: true)
    }
    
    private func showNewProductFlow(currentProducts: [Product], productListId: String) {
        let newProductCoordinator = NewProductCoordinator(navigationController)
        newProductCoordinator.products = currentProducts
        newProductCoordinator.productListID = productListId
        newProductCoordinator.finishDelegate = self
        newProductCoordinator.start()
        childCoordinators.append(newProductCoordinator)
    }
    
    deinit {
        print("ListsCoordinator deinited")
    }
}

extension ListsCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        
    }
}
