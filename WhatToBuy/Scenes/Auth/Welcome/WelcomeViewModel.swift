//
//  WelcomeViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import Foundation

class WelcomeViewModel {
    weak var coordinator: AuthCoordinatorProtocol?
    var didSentEventClosure: ((WelcomeViewModel.Event) -> Void)?
    
    func goToLogin() {
        coordinator?.showSignInViewController()
    }
    
    func goToRegister() {
        coordinator?.showSignUpViewController()
    }
    
    func missAuth() {
        didSentEventClosure?(.missAuth)
    }
}

extension WelcomeViewModel {
    enum Event {
        case missAuth
    }
}
