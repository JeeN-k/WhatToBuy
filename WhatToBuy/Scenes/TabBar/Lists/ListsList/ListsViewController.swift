//
//  ListsViewController.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 21.03.2022.
//

import UIKit

class ListsViewController: UIViewController {
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
    
    var viewModel: ListsViewModelProtocol
    
    init(viewModel: ListsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    //TODO: CHANGE THIS TO DELEGATE
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.activityStartAnimating(backgroundColor: .systemBackground)
        viewModel.fetchLists { [weak self] in
            self?.updateData()
        }
    }
}


//MARK: - UITableViewDelegate
extension ListsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectProductList(indexPath: indexPath)
    }
}

//MARK: - UITableViewDataSource
extension ListsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell",
                                                       for: indexPath) as? ListCellView else {
            return UITableViewCell()
        }
        cell.viewModel = viewModel.viewModelForCell(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.productLists.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.productLists.count == 0 {
            tableView.setEmptyMessage("Нет списков")
        } else {
            tableView.restore()
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeProductListAt(indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}


// MARK: - Private Methods
extension ListsViewController {
    private func configureView() {
        title = "Списки"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                        style: .plain, target: self, action: #selector(newListTouched))
        
        let invitesList = UIBarButtonItem(image: UIImage(systemName: "person.wave.2"),
                                          style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [addButton, invitesList]
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func updateData() {
        view.activityStopAnimating()
        tableView.reloadData()
    }
    
    @objc
    private func newListTouched() {
        viewModel.addNewList()
    }
}
