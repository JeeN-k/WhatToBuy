//
//  AuthenticationService.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import Foundation

protocol AuthenticationServiceProtocol {
    func signIn(user: UserData, completion: @escaping((AuthResponse) -> Void))
    func signUpNewUser(user: UserData, completion: @escaping((AuthResponse) -> Void))
}

class AuthenticationService: AuthenticationServiceProtocol {
    private let netoworkService = NetworkCore.instance
    
    func signIn(user: UserData, completion: @escaping((AuthResponse) -> Void)) {
        let signInRequest = SignInRequest(user: user)
        netoworkService.request(signInRequest) { result in
            switch result {
            case .success(let signInResponse):
                if signInResponse.success,
                    let authToken = signInResponse.authToken,
                    let userData = signInResponse.userData {
                    AccountManager.setAuthToken(token: authToken)
                    AccountManager.setUserData(from: userData)
                }
                completion(signInResponse)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func signUpNewUser(user: UserData, completion: @escaping((AuthResponse) -> Void)) {
        let signUpRequest = SignUpRequest(user: user)
        netoworkService.request(signUpRequest) { result in
            switch result {
            case .success(let signUpResponse):
                completion(signUpResponse)
            case .failure(let error):
                print(error)
            }
        }
    }
}
