//
//  TabBarPage.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 26.03.2022.
//

import Foundation

enum TabBarPage {
    case lists
    case trash
    case settings
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .lists
        case 1:
            self = .trash
        case 2:
            self = .settings
        default:
            return nil
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
        case .lists:
            return "Списки"
        case .trash:
            return "Корзина"
        case .settings:
            return "Настройки"
            
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .lists:
            return 0
        case .trash:
            return 1
        case .settings:
            return 2
            
        }
    }
    
    func pageImageName() -> String {
        switch self {
        case .lists:
            return "list.bullet.rectangle.fill"
        case .trash:
            return "trash.fill"
        case .settings:
            return "gear"
        }
    }
}
