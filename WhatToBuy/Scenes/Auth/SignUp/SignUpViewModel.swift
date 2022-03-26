//
//  SignUpViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import Foundation

final class SignUpViewModel {
    weak var coordinator: AuthCoordinator!
    
    func goToSignIn() {
        coordinator.showSignInViewController()
    }
}
