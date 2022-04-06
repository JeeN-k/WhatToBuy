//
//  InviteToListRequest.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 02.04.2022.
//

import Foundation

struct InviteToListRequest: DataRequest {
    let authToken = AccountManager.authToken ?? ""
    typealias Response = BasicResponse
    let listId: String
    let email: String
    
    init(listId: String, email: String) {
        self.listId = listId
        self.email = email
    }
    
    var urlPath: String {
        "/productlists/invite"
    }
    
    var headers: [String : String] {
        ["auth-token": authToken]
    }
    
    var method: HTTPMethod {
        .patch
    }
    
    var queryItems: [String : String] {
        ["listId": listId, "email": email]
    }
}
