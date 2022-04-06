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
    case exitCell(model: SettingsLogin)
}

enum Sections {
    case user
    case account
    case aboutApp
    case exit
}

struct SettingsSwitchOption {
    let title: String
    let iconName: String
    let isOn: Bool
    let section: Sections
}

struct SettingsAccount {
    let user: UserData?
}

struct SettingsOption {
    let title: String
    let iconName: String
    let section: Sections
}

struct SettingsLogin {
    let isLogined: Bool
}
