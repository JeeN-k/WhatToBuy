//
//  TokenManager.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import Foundation

class AccountManager {
    private static var userDefaults = UserDefaults.standard
    
    static var authToken: String? {
        guard let token = userDefaults.string(forKey: "token") else { return nil }
        return token
    }
    
    static var isOfflineMode: Bool {
        guard let isOffline = userDefaults.value(forKey: "isOffline") as? Bool else { return true }
        return isOffline
    }
    
    static var userData: UserData? {
        guard let userName = userDefaults.string(forKey: "userName"),
              let userEmail = userDefaults.string(forKey: "userEmail") else { return nil }
        return UserData(name: userName, email: userEmail)
    }
    
    static var isPassAuth: Bool {
        let isPassAuth = userDefaults.bool(forKey: "isPassAuth")
        return isPassAuth
    }
    
    static var authTokenExists: Bool { return authToken != nil}
    
    static func setAuthToken(token: String) {
        userDefaults.set(token, forKey: "token")
    }
    
    static func setOfflineMode(is isOffline: Bool) {
        userDefaults.set(isOffline, forKey: "isOffline")
    }
    
    static func setUserData(from user: UserData) {
        userDefaults.set(user.name, forKey: "userName")
        userDefaults.set(user.email, forKey: "userEmail")
    }
    
    static func setUserPassAuth(_ isPass: Bool) {
        userDefaults.set(isPass, forKey: "isPassAuth")
    }
    
    static func removeAuthToken() {
        userDefaults.removeObject(forKey: "token")
    }
    
    static func apiKey() -> String? {
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else { return nil }
        return apiKey
    }
}
