//
//  ProductRequest.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 01.04.2022.
//

import Foundation

struct EditedProductRequestBody: Encodable {
    var name: String
    var price: Float?
    var count: Int?
    var category: String
    var note: String?
}
