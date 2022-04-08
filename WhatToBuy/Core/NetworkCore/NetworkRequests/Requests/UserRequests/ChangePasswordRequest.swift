//
//  ChangePasswordRequest.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 06.04.2022.
//

import Foundation

struct ChangePasswordRequest: DataRequest {
    let authToken = AccountManager.authToken ?? "''"
    typealias Response = BasicResponse
    
    let passwordBody: NewPasswordRequestBody
    
    init(oldPassword: String, newPassword: String) {
        passwordBody = NewPasswordRequestBody(oldPassword: oldPassword, newPassword: newPassword)
    }
    
    var httpBody: Data? {
        let json = try? JSONEncoder().encode(passwordBody)
        return json
    }
    
    var method: HTTPMethod {
        .patch
    }
    
    var headers: [String : String] {
        ["auth-token": authToken]
    }
    
    var urlPath: String {
        "/users/resetPassword"
    }
}
