//
//  SignInViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import Foundation

protocol SignInViewModelProtocol {
    func signIn(email: String, password: String, completion: @escaping(String) -> Void)
    func goToRegister()
}

final class SignInViewModel: SignInViewModelProtocol {
    let authService: AuthenticationServiceProtocol
    var didSentEventClosure: ((SignInViewModel.Event) -> Void)?
    
    init(authService: AuthenticationServiceProtocol) {
        self.authService = authService
    }
    
    func goToRegister() {
        didSentEventClosure?(.showRegister)
    }
    
    func signIn(email: String, password: String, completion: @escaping(String) -> Void) {
        let user = User(email: email, password: password)
        authService.signIn(user: user) { [weak self] response in
            if !response.success {
                completion(response.message)
            } else {
                self?.didSentEventClosure?(.loginSuccessfully)
            }
        }
    }
}

extension SignInViewModel {
    enum Event {
        case loginSuccessfully
        case showRegister
    }
}
