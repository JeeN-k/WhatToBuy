//
//  EditProductViewController.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 01.04.2022.
//

import UIKit

final class EditProductViewContrtoller: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let viewModel: EditProductViewModel
    
    init(viewModel: EditProductViewModel) {
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
}

extension EditProductViewContrtoller: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 3
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerProductCell", for: indexPath) as! EditProductHeaderCell
            cell.viewModel = viewModel.viewModelForCell()
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "fieldProductCell", for: indexPath) as! EditProductFieldsCell
            cell.viewModel = viewModel.viewModelForCell()
            cell.delegate = self
            switch indexPath.row {
            case 0:
                cell.setupCell(type: .count)
            case 1:
                cell.setupCell(type: .price)
            case 2:
                cell.setupCell(type: .note)
            default:
                print("Default case")
            }
            return cell
        }
    }
}

extension EditProductViewContrtoller: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30
        } else {
            return 0
        }
    }
}

extension EditProductViewContrtoller {
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        
        let cancelButton = UIBarButtonItem(title: "Отмена",
                                           style: .plain,
                                           target: self,
                                           action: #selector(cancelUpdateTouch))
        cancelButton.tintColor = .white
        
        let doneButton = UIBarButtonItem(title: "Готово",
                                         style: .done,
                                         target: self,
                                         action: #selector(doneUpdateTouched))
        doneButton.tintColor = .white
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
        view.backgroundColor = .systemIndigo
        view.addSubview(tableView)
        configureTableView()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.register(EditProductHeaderCell.self, forCellReuseIdentifier: "headerProductCell")
        tableView.register(EditProductFieldsCell.self, forCellReuseIdentifier: "fieldProductCell")
    }
    
    @objc
    private func doneUpdateTouched() {
        viewModel.updateProduct()
    }
    
    @objc
    private func cancelUpdateTouch() {
        viewModel.cancelUpdate()
    }
}

extension EditProductViewContrtoller: HeaderEditedDelegate {
    func productNameEdited(name: String?) {
        guard let name = name else { return }
        viewModel.product.name = name
    }
}

extension EditProductViewContrtoller: ProductPropertiesDelegate {
    func propertyEdited(with data: String?, type: EditProductCellType) {
        guard let data = data else { return }
        switch type {
        case .count:
            guard let count = Int(data) else { return }
            viewModel.product.count = count
        case .price:
            guard let price = Float(data) else { return }
            viewModel.product.price = price
        case .note:
            viewModel.product.note = data
        }
    }
}


