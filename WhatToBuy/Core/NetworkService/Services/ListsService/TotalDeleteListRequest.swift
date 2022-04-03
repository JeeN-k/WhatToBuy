//
//  TotalDeleteListRequest.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 03.04.2022.
//

import Foundation

struct TotalDeleteListRequest: DataRequest {
    let authToken = TokenManager.token ?? ""
    typealias Response = BasicResponse
    let listId: String
    
    init(listId: String) {
        self.listId = listId
    }
    
    var urlPath: String {
        "/productlists/\(listId)"
    }
    
    var headers: [String : String] {
        ["auth-token": authToken]
    }
    
    var method: HTTPMethod {
        .delete
    }
}
