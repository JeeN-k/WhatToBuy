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
    
    var product: ProductSectionsBundle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        let dataprovider: DataProviderProtocol = DataProvider()
        dataprovider.fetchLocalProducts { products in
            self.product = products
            self.tableView.reloadData()
            
        }
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource
extension NewProductsCategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product?.sections.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        tableView.setEmptyMessage("Список пуст")
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newProductCategoryCell", for: indexPath)
        cell.textLabel?.text = product?.sections[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - Private Methods
extension NewProductsCategoriesViewController {
    private func configureView() {
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

