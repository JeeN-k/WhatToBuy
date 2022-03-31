//
//  NewListResponse.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 30.03.2022.
//

import Foundation

struct NewListResponse: Codable {
    var success: Bool
    var data: ProductList
}
