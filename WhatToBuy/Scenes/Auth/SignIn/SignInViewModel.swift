//
//  SignInViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import Foundation

final class SignInViewModel {
    weak var coordinator: AuthCoordinator!
    
    func goToRegister() {
        coordinator.showSignUpViewController()
    }
}
