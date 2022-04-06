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
        let authService: AuthenticationServiceProtocol = AuthenticationService()
        let signInViewModel = SignInViewModel(authService: authService)
        let signInViewController = SignInViewController(viewModel: signInViewModel)
        signInViewModel.didSentEventClosure = { [weak self] event in
            switch event {
            case .loginSuccessfully:
                self?.finish()
            case .showRegister:
                signInViewController.dismiss(animated: true)
                self?.showSignUpViewController()
            }
        }
        navigationController.pushViewController(signInViewController, animated: true)
    }
    
    func showSignUpViewController() {
        let authService: AuthenticationServiceProtocol = AuthenticationService()
        let signUpViewModel = SignUpViewModel(authService: authService)
        let signUpViewController = SignUpViewController(viewModel: signUpViewModel)
        signUpViewModel.didSentEventClosure = { [weak self] event in
            switch event {
            case .showLogin:
                self?.showSignInViewController()
            }
        }
        
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
