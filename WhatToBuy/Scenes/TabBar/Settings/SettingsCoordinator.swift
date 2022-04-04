//
//  SettingsCoordinator.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 04.04.2022.
//

import UIKit

class SettingsCoordinator: Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .tab }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showSettingsViewController()
    }
    
    private func showSettingsViewController() {
//        let dataProvider = DataProvider()
//        let trashViewModel = TrashViewModel(dataProvider: dataProvider)
        let settingsViewController = SettingsViewConrtoller()
        navigationController.pushViewController(settingsViewController, animated: true)
    }
    
    deinit {
        print("SettingsCoordinator deinited")
    }
}
