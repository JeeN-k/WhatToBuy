//
//  AcceptInviteRequest.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 02.04.2022.
//

import Foundation

struct AnswerInviteRequest: DataRequest {
    let authToken = TokenManager.token ?? ""
    typealias Response = BasicResponse
    let listId: String
    let answerType: AnswerInviteType
    
    init(listId: String, answerType: AnswerInviteType) {
        self.listId = listId
        self.answerType = answerType
    }
    
    var urlPath: String {
        if answerType == .accept {
            return "/productlists/acceptInvite"
        } else {
            return "/productlists/refuseInvite"
        }
    }
    
    var queryItems: [String : String] {
        ["listId": listId]
    }
    
    var headers: [String : String] {
        ["auth-token": authToken]
    }
    
    var method: HTTPMethod {
        .patch
    }
}

enum AnswerInviteType {
    case accept
    case refuse
}
