//
//  SettingsViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 05.04.2022.
//

import Foundation

final class SettingsViewModel {
    var settingsModel: Observable<[SectionsSetting]> = Observable([])
    weak var coordinator: SettingsCoordinator?
    var didSentEventClosure: ((SettingsViewModel.Event) -> ())?
    
    func changeLoginStatus() {
        if AccountManager.authTokenExists {
            AccountManager.removeAuthToken()
            configureModel()
        } else {
            didSentEventClosure?(.login)
        }
    }
    
    func resetPassword() {
        didSentEventClosure?(.newPassword)
    }
    
    func offlineModeChanged(with state: Bool) {
        AccountManager.setOfflineMode(is: state)
    }
    
    func showAboutApp() {
        didSentEventClosure?(.aboutApp)
    }
    
    func configureModel() {
        settingsModel.value.removeAll()
        if AccountManager.authTokenExists {
            settingsModel.value.append(SectionsSetting(title: "", options: [
                .accountCell(model: SettingsAccount(user: AccountManager.userData))
            ]))
            settingsModel.value.append(SectionsSetting(title: "Аккаунт", options: [
                .staticCell(model: SettingsOption(title: "Сменить пароль", iconName: "pencil", section: .account)),
                .swtichCell(model: SettingsSwitchOption(title: "Локальный режим",
                                                        iconName: "antenna.radiowaves.left.and.right.slash",
                                                        isOn: AccountManager.isOfflineMode,
                                                        section: .account))
            ]))
            settingsModel.value.append(SectionsSetting(title: "Приложение", options: [
                .staticCell(model: SettingsOption(title: "О приложении",
                                                  iconName: "questionmark.circle",
                                                  section: .aboutApp))
            ]))
            
            settingsModel.value.append(SectionsSetting(title: " ", options: [
                .exitCell(model: SettingsLogin(isLogined: AccountManager.authTokenExists))
            ]))
        } else {
            settingsModel.value.append(SectionsSetting(title: " ", options: [
                .exitCell(model: SettingsLogin(isLogined: AccountManager.authTokenExists))
            ]))
            settingsModel.value.append(SectionsSetting(title: "Приложение", options: [
                .staticCell(model: SettingsOption(title: "О приложении",
                                                  iconName: "questionmark.circle",
                                                  section: .aboutApp))
            ]))
        }
    }
}
extension SettingsViewModel {
    enum Event {
        case login
        case newPassword
        case aboutApp
    }
}
