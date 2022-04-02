//
//  EditListViewController.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 01.04.2022.
//

import UIKit

final class EditListViewConrtoller: UIViewController {
    
    lazy var editView: EditListView = {
        let view = EditListView(viewModel: viewModel)
        return view
    }()
    
    let viewModel: EditListViewModelProtocol
    
    init(viewModel: EditListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        self.view = editView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        fillFields()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EditListViewConrtoller {
    private func configureView() {
        title = "Изменить список"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(cancelEditTouched))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(updateTouched))
    }
    
    private func fillFields() {
        editView.nameTextField.text = viewModel.productList.name
        let selectedColorIndex = ListColor(rawValue: viewModel.productList.color)?.index ?? 0
        let selectedIconIndex = ListIcon(rawValue: viewModel.productList.icon)?.index ?? 0
        editView.iconPicker.selectRow(selectedColorIndex, inComponent: 0, animated: true)
        editView.iconPicker.selectRow(selectedIconIndex, inComponent: 1, animated: true)
    }
    
    @objc
    private func updateTouched() {
        guard let text = editView.nameTextField.text, text != "" else { return }
        viewModel.updateList(name: text)
    }
    
    @objc
    private func cancelEditTouched() {
        viewModel.cancelEdit()
    }
}
