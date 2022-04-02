//
//  ProductListRequestBody.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 01.04.2022.
//

import Foundation

struct ProductListRequestBody: Encodable {
    var name: String
    var color: String
    var icon: String
}
