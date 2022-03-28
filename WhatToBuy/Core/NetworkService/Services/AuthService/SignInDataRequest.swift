//
//  SignInDataRequest.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 28.03.2022.
//

import Foundation

struct SignInRequest: DataRequest {
    private let apiKey: String = TokenManager.apiKey() ?? ""
    let user: User
    
    init(user: User) {
        self.user = user
    }
    
    var httpBody: Data? {
        let json = try? JSONEncoder().encode(user)
        return json
    }
    
    var headers: [String : String] {
        ["app-token": apiKey]
    }
    
    var url: String {
        let baseURL = "https://digitalleagueapp.ru/api"
        let path = "/auth/signIn"
        return baseURL + path
    }
    
    var method: HTTPMethod = .post
    
    typealias Response = SignInResponse
    
    
}
