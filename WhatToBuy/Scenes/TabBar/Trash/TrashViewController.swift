//
//  TrashViewController.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 31.03.2022.
//

import UIKit

final class TrashViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 68
        tableView.separatorStyle = .none
        tableView.register(ListCellView.self, forCellReuseIdentifier: "listCell")
        return tableView
    }()
    
    let viewModel: TrashViewModelProtocol
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.activityStartAnimating(backgroundColor: .systemBackground)
        viewModel.fetchRemovedLists {
            self.updateData()
        }
    }
    
    init(viewModel: TrashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrashViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.numberOfItems() == 0 {
            tableView.setEmptyMessage("Корзина пуста")
        } else {
            tableView.restore()
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
                as? ListCellView else { return UITableViewCell() }
        cell.viewModel = viewModel.viewModelForCell(at: indexPath)
        return cell
    }
}

extension TrashViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { (action, view, handler) in
            self.deleteListTouched(at: indexPath)
        }
        
        let restoreAction = UIContextualAction(style: .normal, title: "Вернуть") { (action, view, handler) in
            self.restoreListTouched(at: indexPath)
        }
        
        deleteAction.backgroundColor = .systemRed
        restoreAction.backgroundColor = .systemGreen
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, restoreAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

extension TrashViewController {
    private func configureView() {
        title = "Корзина"
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
    
    private func deleteListTouched(at indexPath: IndexPath) {
        viewModel.deleteList(at: indexPath)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    private func restoreListTouched(at indexPath: IndexPath) {
        viewModel.restoreList(at: indexPath)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    private func updateData() {
        tableView.reloadData()
        view.activityStopAnimating()
    }
}
