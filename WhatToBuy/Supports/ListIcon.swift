//
//  Icons.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import Foundation

enum ListIcon: String, CaseIterable {
    case document
    case basket
    case gift
    case sale
    case bowtie
    case heart
    case car
    case construcs
    case rose
    
    var iconName: String {
        get {
            switch self {
            case .document:
                return "Document"
            case .basket:
                return "Basket"
            case .gift:
                return "Gift"
            case .sale:
                return "Sale"
            case .bowtie:
                return "Bowtie"
            case .heart:
                return "Heart"
            case .car:
                return "Car"
            case .construcs:
                return "Construcs"
            case .rose:
                return "Rose"
            }
        }
    }
}
