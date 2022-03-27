//
//  ProductsViewController.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 23.03.2022.
//

import UIKit

class ProductsViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 56
        tableView.register(ProductViewCell.self, forCellReuseIdentifier: "productCell")
        return tableView
    }()
    
    var viewModel: ProductsViewModelProtocol
    
    init(viewModel: ProductsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        viewModel.fetchProducts { [weak self] in
            self?.updateData()
        }
    }
}


//MARK: - UITableViewDelegate & UITableViewDataSource
extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.products.count == 0 {
            tableView.setEmptyMessage("Список пуст")
            return 0
        } else {
            tableView.restore()
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .systemPink
        header.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Fruits"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productCell",
                                                       for: indexPath) as? ProductViewCell else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - Private Methods
extension ProductsViewController {
    private func configureView() {
        title = viewModel.titleForView()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Добавить продукт",
                                                            style: .done, target: self,
                                                            action: #selector(newProductTouched))
        
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
    
    @objc
    private func newProductTouched() {
        viewModel.addProduct()
    }
}
