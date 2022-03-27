//
//  NewProductsCategoriesViewController.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 25.03.2022.
//

import UIKit

class NewProductsCategoriesViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "newProductCategoryCell")
        return tableView
    }()
    
    let viewModel: NewProductsCategoriesViewModelProtocol
    
    init(viewModel: NewProductsCategoriesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        viewModel.fetchProductCategories { [weak self] in
            self?.updateData()
        }
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource
extension NewProductsCategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.productCategories.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newProductCategoryCell", for: indexPath)
        cell.textLabel?.text = viewModel.productCategories[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.categorySelected(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - Private Methods
extension NewProductsCategoriesViewController {
    private func configureView() {
        title = "Категории"
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
        self.tableView.reloadData()
    }
}

