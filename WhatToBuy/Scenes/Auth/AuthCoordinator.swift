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
        let signInViewModel = SignInViewModel()
        let signInViewController = SignInViewController(viewModel: signInViewModel)
        signInViewModel.coordinator = self
        navigationController.pushViewController(signInViewController, animated: true)
    }
    
    func showSignUpViewController() {
        let signUpViewModel = SignUpViewModel()
        let signUpViewController = SignUpViewController(viewModel: signUpViewModel)
        signUpViewModel.coordinator = self
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
