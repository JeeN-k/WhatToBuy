//
//  SignInResponse.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 28.03.2022.
//

import Foundation

struct SignInResponse: Codable {
    var success: Bool
    var message: String
    var authToken: String?
}
