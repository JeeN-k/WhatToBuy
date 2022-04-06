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
    var type: CoordinatorType { .settings }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showSettingsViewController()
    }
    
    private func showSettingsViewController() {
//        let dataProvider = DataProvider()
        let settingsViewModel = SettingsViewModel()
        settingsViewModel.coordinator = self
        let settingsViewController = SettingsViewConrtoller(viewModel: settingsViewModel)
        settingsViewModel.didSentEventClosure = { event in
            switch event {
            case .login:
                self.showAuthViewController()
            case .newPassword:
                self.showChangePasswordViewController()
            case .aboutApp:
                self.showAboutAppViewController()
            }
        }
        navigationController.pushViewController(settingsViewController, animated: true)
    }
    
    private func showAboutAppViewController() {
        let aboutAppViewController = AboutViewController()
        navigationController.pushViewController(aboutAppViewController, animated: true)
    }
    
    private func showChangePasswordViewController() {
        let dataProvider = DataProvider()
        let changePasswordViewModel = ChangePasswordViewModel(dataProvider: dataProvider)
        let changePasswordViewController = ChangePasswordViewController(viewModel: changePasswordViewModel)
        changePasswordViewModel.didSentEventClosure = { event in
            switch event {
            case .successfullyChanged:
                changePasswordViewController.dismiss(animated: true)
            }
        }
        navigationController.present(changePasswordViewController, animated: true)
    }
    
    private func showAuthViewController() {
        let authService = AuthenticationService()
        let signInViewModel = SignInViewModel(authService: authService)
        let signInViewCotroller = SignInViewController(viewModel: signInViewModel)
        signInViewModel.didSentEventClosure = { [weak self] event in
            switch event {
            case .loginSuccessfully:
                signInViewCotroller.dismiss(animated: true) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateAfterDismiss"), object: nil)
                }
            case .showRegister:
                signInViewCotroller.dismiss(animated: true)
                self?.showRegisterViewController()
            }
        }
        navigationController.present(signInViewCotroller, animated: true)
    }
    
    private func showRegisterViewController() {
        let authService: AuthenticationServiceProtocol = AuthenticationService()
        let signUpViewModel = SignUpViewModel(authService: authService)
        let signUpViewController = SignUpViewController(viewModel: signUpViewModel)
        signUpViewModel.didSentEventClosure = { [weak self] event in
            switch event {
            case .showLogin:
                signUpViewController.dismiss(animated: true)
                self?.showAuthViewController()
            }
        }
        navigationController.present(signUpViewController, animated: true)
    }
    
    deinit {
        print("SettingsCoordinator deinited")
    }
}
