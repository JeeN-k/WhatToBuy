//
//  ListsCoordinator.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import UIKit

protocol ListsCoordinatorProtocol: Coordinator {
    func showListsViewController()
}

class ListsCoordinator: ListsCoordinatorProtocol {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .auth }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showListsViewController()
    }
    
    func showListsViewController() {
        let listsViewController = ListsViewController()
        let listsViewModel = ListsViewModel()
        listsViewModel.coordinator = self
        listsViewModel.didSentEventClosure = { [weak self] event in
            if event == .addList {
                self?.showNewListViewController()
            }
        }
        listsViewController.viewModel = listsViewModel
        navigationController.pushViewController(listsViewController, animated: true)
    }
    
    func showNewListViewController() {
        let newListViewController = AddListViewController()
        let newListViewModel = AddListViewModel()
        newListViewModel.coordinator = self
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
    
    deinit {
        print("AuthCoordinator deinited")
    }
}
