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
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refreshLists), for: .valueChanged)
        refresher.tintColor = .systemIndigo
        refresher.attributedTitle = NSAttributedString(string: "Обновление", attributes: [:])
        return refresher
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.activityStartAnimating(backgroundColor: .systemBackground)
        fetchData()
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
                                        style: .plain,
                                        target: self,
                                        action: #selector(newListTouched))
        
        let invitesList = UIBarButtonItem(image: UIImage(systemName: "person.wave.2"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(invitesTouched))
        navigationItem.rightBarButtonItems = [addButton, invitesList]
        
        view.addSubview(tableView)
        tableView.addSubview(refreshControl)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func updateData() {
        view.activityStopAnimating()
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    private func fetchData() {
        viewModel.fetchLists { [weak self] in
            self?.updateData()
        }
    }
    
    @objc
    private func refreshLists() {
        fetchData()
    }
    
    @objc
    private func newListTouched() {
        viewModel.addNewList()
    }
    
    @objc
    private func invitesTouched() {
        viewModel.showInvitesFlow()
    }
}
