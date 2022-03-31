//
//  TrashCoordinator.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 31.03.2022.
//

import UIKit

class TrashCoordinator: Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .tab }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showTrashViewController()
    }
    
    private func showTrashViewController() {
        let dataProvider = DataProvider()
        let trashViewModel = TrashViewModel(dataProvider: dataProvider)
        let trashViewController = TrashViewController(viewModel: trashViewModel)
        navigationController.pushViewController(trashViewController, animated: true)
    }
    
    deinit {
        print("TrashCoordinator deinited")
    }
}

