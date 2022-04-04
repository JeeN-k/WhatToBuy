//
//  SettingModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 04.04.2022.
//

import Foundation

struct SectionsSetting {
    var title: String
    let options: [SettingsOptionType]
}

enum SettingsOptionType {
    case accountCell(model: SettingsAccount)
    case staticCell(model: SettingsOption)
    case swtichCell(model: SettingsSwitchOption)
    case exitCell
}

struct SettingsSwitchOption {
    let title: String
    let iconName: String
    let isOn: Bool
}

struct SettingsAccount {
    let name: String
    let email: String
}

struct SettingsOption {
    let title: String
    let iconName: String
}
