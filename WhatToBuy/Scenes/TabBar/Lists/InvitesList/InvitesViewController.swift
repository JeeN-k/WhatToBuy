//
//  InvitesListViewController.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 02.04.2022.
//

import UIKit

final class InvitesListViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 56
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(InviteCellView.self, forCellReuseIdentifier: "inviteCell")
        return tableView
    }()
    
    let viewModel: InvitesViewModelProtocol
    
    init(viewModel: InvitesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        viewModel.fetchInvites()
        viewModel.invites.bind { _ in
            self.updateData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InvitesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.numberOfItems() == 0 {
            tableView.setEmptyMessage("Нет приглашений")
        } else {
            tableView.restore()
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "inviteCell", for: indexPath)
                as? InviteCellView else { return UITableViewCell() }
        cell.viewModel = viewModel.viewModelForCell(at: indexPath)
        return cell
    }
}

extension InvitesListViewController: UITableViewDelegate {
    
}

extension InvitesListViewController {
    private func configureView() {
        title = "Приглашения"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func updateData() {
        tableView.reloadData()
    }
}

