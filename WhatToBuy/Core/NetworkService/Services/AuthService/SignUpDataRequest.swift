//
//  SignUpDataRequest.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 28.03.2022.
//

import Foundation

struct SignUpRequest: DataRequest {
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
    
    var urlPath: String {
        return "/auth/signUp"
    }
    
    var method: HTTPMethod = .post
    
    typealias Response = AuthResponse
    
    
}
