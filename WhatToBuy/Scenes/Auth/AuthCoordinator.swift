//
//  AuthCoordinator.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 25.03.2022.
//

import UIKit

protocol AuthCoordinatorProtocol: Coordinator {
    func showSignInViewController()
    func showSignUpViewController()
}

class AuthCoordinator: AuthCoordinatorProtocol {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .auth }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showWelcomeViewController()
    }
    
    func showSignInViewController() {
        let signInViewController = SignInViewController()
        let signInViewModel = SignInViewModel()
        signInViewModel.coordinator = self
        signInViewController.viewModel = signInViewModel
        navigationController.pushViewController(signInViewController, animated: true)
    }
    
    func showSignUpViewController() {
        let signUpViewController = SignUpViewController()
        let signUpViewModel = SignUpViewModel()
        signUpViewModel.coordinator = self
        signUpViewController.viewModel = signUpViewModel
        navigationController.pushViewController(signUpViewController, animated: true)
    }
    
    func showWelcomeViewController() {
        let welcomeViewController = WelcomeViewController()
        let welcomeViewModel = WelcomeViewModel()
        welcomeViewModel.coordinator = self
        welcomeViewModel.didSentEventClosure = { [weak self] event in
            if event == .missAuth {
                self?.finish()
            }
        }
        welcomeViewController.viewModel = welcomeViewModel
        navigationController.pushViewController(welcomeViewController, animated: true)
    }
    
    deinit {
        print("AuthCoordinator deinited")
    }
}
