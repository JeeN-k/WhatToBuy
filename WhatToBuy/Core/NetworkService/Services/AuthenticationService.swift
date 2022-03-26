//
//  AuthenticationService.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import Foundation

protocol AuthenticationServiceProtocol {
    func signIn(email: String, password: String, completion: @escaping((String) -> Void))
    func signUp(userData: User, completion: @escaping(() -> Void))
}

class AuthenticationService: AuthenticationServiceProtocol {
    func signIn(email: String, password: String, completion: @escaping ((String) -> Void)) {
        
    }
    
    func signUp(userData: User, completion: @escaping (() -> Void)) {
        
    }
}
