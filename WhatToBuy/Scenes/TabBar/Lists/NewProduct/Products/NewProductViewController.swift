//
//  NewProductViewController.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 25.03.2022.
//

import UIKit

class NewProductViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 56
        tableView.register(NewProductCellView.self, forCellReuseIdentifier: "newProductCell")
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchBar = UISearchController()
        searchBar.obscuresBackgroundDuringPresentation = false
        searchBar.searchBar.placeholder = "Поиск"
        searchBar.searchResultsUpdater = self
        return searchBar
    }()
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isSearching: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    var viewModel: NewProductViewModelProtocol
    
    init(viewModel: NewProductViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        viewModel.products.bind { _ in
            self.reloadView()
        }
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource
extension NewProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(isSearching: isSearching)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newProductCell", for: indexPath)
                as? NewProductCellView else { return UITableViewCell() }
        cell.viewModel = viewModel.viewModelForCell(at: indexPath, isSearching: isSearching)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.productTouched(at: indexPath, isSearching: isSearching)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NewProductViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.filterProductsWith(text: searchText)
        self.tableView.reloadData()
    }
}


// MARK: - Private Methods
extension NewProductViewController {
    private func configureView() {
        title = viewModel.titleForView()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        definesPresentationContext = true
        navigationItem.searchController = searchController
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func reloadView() {
        tableView.reloadData()
    }
}

