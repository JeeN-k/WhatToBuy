//
//  FetchInvites.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 02.04.2022.
//

import Foundation

struct FetchInvitesRequest: DataRequest {
    let authToken = TokenManager.token ?? ""
    typealias Response = InviteResponse
    
    var urlPath: String {
        "/productlists/invites"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String : String] {
        ["auth-token": authToken]
    }
}
