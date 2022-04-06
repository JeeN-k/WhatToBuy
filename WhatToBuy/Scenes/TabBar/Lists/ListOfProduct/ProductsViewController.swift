//
//  ProductsViewController.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 23.03.2022.
//

import UIKit

class ProductsViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 56
        tableView.register(ProductViewCell.self, forCellReuseIdentifier: "productCell")
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Обновление")
        refresher.addTarget(self, action: #selector(refreshProducts), for: .valueChanged)
        refresher.tintColor = .systemIndigo
        return refresher
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.activityStartAnimating(backgroundColor: .systemBackground)
        refreshProducts()
    }
}


//MARK: - UITableViewDataSource
extension ProductsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(at: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.numberOfSections() == 0 {
            tableView.setEmptyMessage("Список пуст")
        } else {
            tableView.restore()
        }
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForSection(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productCell",
                                                       for: indexPath) as? ProductViewCell else { return UITableViewCell() }
        cell.viewModel = viewModel.viewModelForCell(at: indexPath)
        return cell
    }
}


//MARK: - UITableViewDelegate
extension ProductsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .systemIndigo
        header.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.updateIsBought(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        let indexSet = IndexSet(integer: indexPath.section)
        tableView.reloadSections(indexSet, with: .fade)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { (action, view, handler) in
            self.deleteProduct(at: indexPath)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Изменить") { action, view, handler in
            self.viewModel.openEditProductFlow(at: indexPath)
        }
        deleteAction.backgroundColor = .systemRed
        editAction.backgroundColor = .systemYellow
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return configuration
    }
}


// MARK: - Private Methods
extension ProductsViewController {
    private func configureView() {
        title = viewModel.titleForView()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(newProductTouched))
        
        let editButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(editListTouched))
        
        let invitesButton = UIBarButtonItem(image: UIImage(systemName: "person.badge.plus"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(inviteUserTouched))
        
        navigationItem.rightBarButtonItems = [addButton, editButton, invitesButton]
        view.addSubview(tableView)
        tableView.addSubview(refreshControl)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func deleteProduct(at indexPath: IndexPath) {
        viewModel.deleteProduct(at: indexPath)
        if viewModel.numberOfRows(at: indexPath.section) == 1 {
            viewModel.removeSection(at: indexPath.section)
            let indexSet = IndexSet(arrayLiteral: indexPath.section)
            tableView.deleteSections(indexSet, with: .fade)
        } else {
            viewModel.removeProduct(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @objc
    private func refreshProducts() {
        fetchProducts()
    }
    
    private func updateData() {
        view.activityStopAnimating()
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    private func fetchProducts() {
        viewModel.fetchProducts { [weak self] in
            self?.updateData()
        }
    }
    
    @objc
    private func newProductTouched() {
        viewModel.openNewProductFlow()
//        showNewProductAlert()
    }
    
    @objc
    private func editListTouched() {
        viewModel.editProductsList()
    }
    
    @objc
    private func inviteUserTouched() {
        showInviteAlert()
    }
    
    private func inviteUserToList(email: String?) {
        guard let email = email, email != "" else { return }
        viewModel.inviteUser(email: email) { [weak self] message in
            self?.showAlertWith(text: message)
        }
    }
    
    private func showInviteAlert() {
        let ac = UIAlertController(title: "Пригласите друга для совместного редактирования",
                                   message: "Ввведите email пользователя которого хотите пригласить",
                                   preferredStyle: .alert)
        ac.addTextField { textfield in
            textfield.keyboardType = .emailAddress
            textfield.placeholder = "Email"
        }
        
        let acCancel = UIAlertAction(title: "Отмена", style: .cancel)
        let acDone = UIAlertAction(title: "Пригласить", style: .default, handler: { [weak self] _ in
            let email = ac.textFields![0].text
            self?.inviteUserToList(email: email)
        })
        ac.addAction(acCancel)
        ac.addAction(acDone)
        present(ac, animated: true)
    }
}
