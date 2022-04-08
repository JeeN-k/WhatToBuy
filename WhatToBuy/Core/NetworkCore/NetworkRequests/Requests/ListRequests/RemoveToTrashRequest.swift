//
//  RemoveToTrashRequest.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 30.03.2022.
//

import Foundation

struct RemoveToTrashRequest: DataRequest {
    let authToken = AccountManager.authToken ?? ""
    typealias Response = BasicResponse
    let listId: String
    
    init(listId: String) {
        self.listId = listId
    }
    
    var urlPath: String {
        "/productlists/removeToTrash"
    }
    
    var headers: [String : String] {
        ["auth-token": authToken]
    }
    
    var method: HTTPMethod {
        .patch
    }
    
    var queryItems: [String : String] {
        ["listId": listId]
    }
}
