//
//  AuthenticationService.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import Foundation

protocol AuthenticationServiceProtocol {
    func signIn(user: User, completion: @escaping((AuthResponse) -> Void))
    func signUpNewUser(user: User, completion: @escaping((AuthResponse) -> Void))
}

class AuthenticationService: AuthenticationServiceProtocol {
    private let netoworkService = NetworkService.instance
    
    func signIn(user: User, completion: @escaping((AuthResponse) -> Void)) {
        let signInRequest = SignInRequest(user: user)
        netoworkService.request(signInRequest) { result in
            switch result {
            case .success(let signInResponse):
                let authToken = signInResponse.authToken
                if signInResponse.success, let authToken = authToken {
                    TokenManager.setAuthToken(token: authToken)
                }
                completion(signInResponse)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func signUpNewUser(user: User, completion: @escaping((AuthResponse) -> Void)) {
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
