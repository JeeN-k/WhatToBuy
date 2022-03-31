//
//  Colors.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import Foundation

enum ListColor: String, CaseIterable {
    case green
    case purple
    case yellow
    case gray
    case red
    case beige
    case blue
    case orange
    case lightGreen
    case pink
    case lightPurple
    case brown
    
    var hexColor: String {
        get {
            switch self {
            case .green:
                return "#047C52"
            case .purple:
                return "#524C8C"
            case .yellow:
                return "#FFE200"
            case .gray:
                return "#6E7972"
            case .red:
                return "#D23D33"
            case .beige:
                return "#C1A386"
            case .blue:
                return "#64D2FF"
            case .orange:
                return "#FF9F0A"
            case .lightGreen:
                return "#00EA96"
            case .pink:
                return "#E1289B"
            case .lightPurple:
                return "#BF5AF2"
            case .brown:
                return "#734230"
            }
        }
    }
}
