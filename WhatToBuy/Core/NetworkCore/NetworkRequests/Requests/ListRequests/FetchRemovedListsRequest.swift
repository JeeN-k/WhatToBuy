//
//  FetchRemovedListsRequest.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 31.03.2022.
//

import Foundation

struct FetchRemovedListsRequest: DataRequest {
    let authToken = AccountManager.authToken ?? ""
    typealias Response = ProductListResponse
    
    var urlPath: String {
        "/productlists/byUserRemoved"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String : String] {
        ["auth-token": authToken]
    }
}
