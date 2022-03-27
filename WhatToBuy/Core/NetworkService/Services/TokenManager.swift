//
//  TokenManager.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import Foundation

class TokenManager {
    private static var userDefaults = UserDefaults.standard
    
    static var token: String? {
        guard let token = userDefaults.string(forKey: "token") else { return nil }
        return token
    }
    
    static var tokenExists: Bool { return token != nil}
    
    static func setAuthToken(token: String) {
        userDefaults.set(token, forKey: "token")
    }
    
    static func removeAuthToken() {
        userDefaults.removeObject(forKey: "token")
    }
}
