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
    
    let viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        viewModel.settingsModel.bind { _ in
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.configureModel()
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
            return viewModel.settingsModel.value[section].options.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.settingsModel.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.settingsModel.value[indexPath.section].options[indexPath.row]
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
            cell.didSwitchChangeAction = { state in
                self.viewModel.offlineModeChanged(with: state)
            }
            return cell
        case .exitCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "exitCell",
                for: indexPath) as? ExitAccountCell else { return UITableViewCell() }
            cell.configureCell(from: model)
            return cell
        }
    }
}

extension SettingsViewConrtoller: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = viewModel.settingsModel.value[indexPath.section].options[indexPath.row]
        switch model {
        case .accountCell:
            return 80
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else {
            return viewModel.settingsModel.value[section].title
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.settingsModel.value[indexPath.section].options[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        switch model {
        case .exitCell:
            viewModel.changeLoginStatus()
        case .staticCell(let model):
            if model.section == .account {
                viewModel.resetPassword()
            } else if model.section == .aboutApp {
                viewModel.showAboutApp()
            }
        default:
            return
        }
    }
}

extension SettingsViewConrtoller {
    private func configureView() {
        title = "Настройки"
        navigationController?.navigationBar.prefersLargeTitles = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateView),
                                               name: NSNotification.Name(rawValue: "UpdateAfterDismiss"),
                                               object: nil)
    }
    
    @objc
    private func updateView() {
        viewModel.configureModel()
    }
}
