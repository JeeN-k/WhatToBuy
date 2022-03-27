//
//  TabBarCoordinator.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 25.03.2022.
//

import UIKit

protocol TabBarCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
    func selectPage(_ page: TabBarPage)
    func setSelectedIndex(_ index: Int)
    func currentPage() -> TabBarPage?
}

final class TabBarCoordinator: NSObject, TabBarCoordinatorProtocol {
    var tabBarController: UITabBarController
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .tab }
    
    required init(_ navigationController: UINavigationController) {
        self.tabBarController = .init()
        self.navigationController = navigationController
    }
    
    func start() {
        let pages: [TabBarPage] = [.lists, .trash, .settings]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        let contollers: [UINavigationController] = pages.map({ getTabBarController($0) })
        prepareTabBarController(with: contollers)
    }
    
    private func prepareTabBarController(with tabControllers: [UIViewController]) {
        tabBarController.delegate = self
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.lists.pageOrderNumber()
        tabBarController.tabBar.backgroundColor = .secondarySystemBackground
        navigationController.viewControllers = [tabBarController]
    }
    
    private func getTabBarController(_ page: TabBarPage) -> UINavigationController {
        let navVC = UINavigationController()
        navVC.tabBarItem = UITabBarItem(title: page.pageTitleValue(),
                                        image: UIImage(systemName: page.pageImageName()),
                                        tag: page.pageOrderNumber())
        switch page {
        case .lists:
            let listsCoordinator = ListsCoordinator(navVC)
            listsCoordinator.finishDelegate = self
            childCoordinators.append(listsCoordinator)
            listsCoordinator.start()
        case .trash:
            let trashVC = UIViewController()
            navVC.pushViewController(trashVC, animated: true)
        case .settings:
            let settingsVC = UIViewController()
            navVC.pushViewController(settingsVC, animated: true)
        }
        return navVC
    }
    
    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage(index: index) else { return }
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func currentPage() -> TabBarPage? {
        TabBarPage(index: tabBarController.selectedIndex)
    }
}

extension TabBarCoordinator: UITabBarControllerDelegate {
    
}

extension TabBarCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        
    }
}