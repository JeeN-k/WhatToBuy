//
//  SettingsViewController.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 04.04.2022.
//

import UIKit

final class SettingsViewConrtoller: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AccountCell.self, forCellReuseIdentifier: "accountCell")
        tableView.register(SettingCell.self, forCellReuseIdentifier: "settingCell")
        tableView.register(SwitchSettingCell.self, forCellReuseIdentifier: "switchSettingCell")
        tableView.register(ExitAccountCell.self, forCellReuseIdentifier: "exitCell")
        return tableView
    }()
    
    var settingsModel: [SectionsSetting] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
}

extension SettingsViewConrtoller: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return settingsModel[section].options.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = settingsModel[indexPath.section].options[indexPath.row]
        switch model {
        case .accountCell(let model):
            guard let cell  = tableView.dequeueReusableCell(
                withIdentifier: "accountCell",
                for: indexPath) as? AccountCell else { return UITableViewCell() }
            cell.configureCell(from: model)
            tableView.separatorStyle = .none
            return cell
        case .staticCell(let model):
            guard let cell  = tableView.dequeueReusableCell(
                withIdentifier: "settingCell",
                for: indexPath) as? SettingCell else { return UITableViewCell() }
            cell.configureCell(from: model)
            return cell
        case .swtichCell(let model):
            guard let cell  = tableView.dequeueReusableCell(
                withIdentifier: "switchSettingCell",
                for: indexPath) as? SwitchSettingCell else { return UITableViewCell() }
            cell.configureCell(from: model)
            return cell
        case .exitCell:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "exitCell",
                for: indexPath) as? ExitAccountCell else { return UITableViewCell() }
            return cell
        }
    }
}

extension SettingsViewConrtoller: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else {
            return settingsModel[section].title
        }
    }
}

extension SettingsViewConrtoller {
    private func configureView() {
        title = "Настройки"
        navigationController?.navigationBar.prefersLargeTitles = true
        configureModel()
    }
    
    private func configureModel() {
        settingsModel.append(SectionsSetting(title: "", options: [
            .accountCell(model: SettingsAccount(name: "My name", email: "example@gmail.com"))
        ]))
        settingsModel.append(SectionsSetting(title: "Аккаунт", options: [
            .staticCell(model: SettingsOption(title: "Сменить пароль", iconName: "pencil")),
            .swtichCell(model: SettingsSwitchOption(title: "Оффлайн-режим", iconName: "person.fill.xmark", isOn: false))
        ]))
        settingsModel.append(SectionsSetting(title: " ", options: [
            .exitCell
        ]))
    }
}
