//
//  SignUpViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import Foundation

protocol SignUpViewModelProtocol {
    func signUpUser(name: String, password: String, email: String, completion: @escaping((String) -> Void))
    func goToSignIn()
}

final class SignUpViewModel: SignUpViewModelProtocol {
    let authService: AuthenticationServiceProtocol
    var didSentEventClosure: ((SignUpViewModel.Event) -> Void)?

    init(authService: AuthenticationServiceProtocol) {
        self.authService = authService
    }
    
    func signUpUser(name: String, password: String, email: String, completion: @escaping((String) -> Void)) {
        let user = UserData(name: name, email: email, password: password)
        authService.signUpNewUser(user: user) { response in
            completion(response.message)
        }
    }
    
    func goToSignIn() {
        didSentEventClosure?(.showLogin)
    }
}

extension SignUpViewModel {
    enum Event {
        case showLogin
    }
}
