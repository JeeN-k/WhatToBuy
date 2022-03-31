//
//  NewProductResponse.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 30.03.2022.
//

import Foundation

struct NewProductResponse: Codable {
    var success: Bool
    var data: Product
}
