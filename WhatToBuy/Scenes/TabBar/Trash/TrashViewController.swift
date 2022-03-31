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
    
    let viewModel: TrashViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        viewModel.fetchRemovedLists {
            self.tableView.reloadData()
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
        return viewModel.productLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
                as? ListCellView else { return UITableViewCell() }
        cell.viewModel = viewModel.viewModelForCell(at: indexPath)
        return cell
    }
}

extension TrashViewController: UITableViewDelegate {
    
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
}
