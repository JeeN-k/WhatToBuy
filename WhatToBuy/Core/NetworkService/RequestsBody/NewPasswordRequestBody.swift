//
//  NewPasswordRequestBody.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 06.04.2022.
//

import Foundation

struct NewPasswordRequestBody: Encodable {
    let oldPassword: String
    let newPassword: String
}
