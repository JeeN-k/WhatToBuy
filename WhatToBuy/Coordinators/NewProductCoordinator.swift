//
//  NewProductCoordinator.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 28.03.2022.
//

import UIKit

class NewProductCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .tab }
    
    var products: [Product] = []
    var productListID: String?
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showNewProductCategoryViewController()
    }
    
    func showNewProductCategoryViewController() {
        let dataProvider: DataProviderProtocol = DataProvider()
        let newProductCategoryViewModel = NewProductsCategoriesViewModel(dataProvider: dataProvider)
        let newProductCategoryController = NewProductsCategoriesViewController(viewModel: newProductCategoryViewModel)
        newProductCategoryViewModel.didSentEventClosure = { [weak self] event in
            switch event {
            case .selectCategory(let category):
                self?.showProductsOfCategory(productCategory: category)
            }
        }
        navigationController.pushViewController(newProductCategoryController, animated: true)
    }
    
    func showProductsOfCategory(productCategory: ProductSectionsBundle) {
        let dataProvider: DataProviderProtocol = DataProvider()
        let newProductsViewModel = NewProductViewModel(dataProvider: dataProvider,
                                                       productCategory: productCategory,
                                                       products: products,
                                                       productListId: productListID ?? "0")
        newProductsViewModel.coordinator = self
        let newProductsViewConrtoller = NewProductViewController(viewModel: newProductsViewModel)
        navigationController.pushViewController(newProductsViewConrtoller, animated: true)
    }
    
    deinit {
        print("NewProductCoordinator deinited")
    }
}
