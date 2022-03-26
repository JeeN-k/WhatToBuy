//
//  ListsViewController.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 21.03.2022.
//

import UIKit

class ListsViewController: UIViewController {
    var viewModel: ListsViewModel?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.fetchLists { [weak self] in
            guard let self = self else { return }
            self.updateData()
        }
    }
}


//MARK: - UITableViewDelegate & UITableViewDataSource
extension ListsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.productLists.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel?.productLists.count == 0 {
            tableView.setEmptyMessage("Нет списков")
        } else {
            tableView.restore()
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? ListCellView else {
            return UITableViewCell()
        }
        cell.viewModel = viewModel?.viewModelForCell(indexPath: indexPath)
        return cell
    }
}


// MARK: - Private Methods
extension ListsViewController {
    private func configureView() {
        title = "Списки"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Добавить", style: .done, target: self, action: #selector(newListTouched))
        
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
    
    @objc private func newListTouched() {
        viewModel?.addNewList()
    }
}
