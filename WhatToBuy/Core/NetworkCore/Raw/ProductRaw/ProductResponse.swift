//
//  ProductResponse.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 27.03.2022.
//

import Foundation

struct ProductResponse: Codable {
    var success: Bool
    var products: [Product]
}
