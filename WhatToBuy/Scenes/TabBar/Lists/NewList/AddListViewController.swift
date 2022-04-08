//
//  AddListViewController.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 23.03.2022.
//

import UIKit

class AddListViewController: UIViewController {
    
    let viewModel: AddListViewModelProtocol
    
    init(viewModel: AddListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    lazy var editView: EditListView = {
        let view = EditListView(viewModel: viewModel)
        return view
    }()
    
    override func loadView() {
        super.loadView()
        self.view = editView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddListViewController {
    private func configureView() {
        title = "Новый список"
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: self,
                                            action: #selector(addListTouched))
        doneBarButton.isEnabled = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(cancelAddingTouched))
        navigationItem.rightBarButtonItem = doneBarButton
        
        editView.didTextChanged = { isTestEmpty in
            doneBarButton.isEnabled = !isTestEmpty
        }
    }
    
    @objc
    private func cancelAddingTouched() {
        viewModel.cancelAdding()
    }
    
    @objc
    private func addListTouched() {
        viewModel.createNewList(name: editView.nameTextField.text)
    }
}
