//
//  User.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import Foundation

struct UserData: Codable {
    var name: String?
    var email: String
    var password: String?
}
