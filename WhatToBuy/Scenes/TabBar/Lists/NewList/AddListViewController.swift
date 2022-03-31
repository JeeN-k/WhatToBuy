//
//  AddListViewController.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 23.03.2022.
//

import UIKit

class AddListViewController: UIViewController {
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 22)
        textField.placeholder = "Новый список"
        return textField
    }()
    
    private lazy var colorLabel: UILabel = {
        let label = UILabel()
        label.text = "Внешний вид"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var colorPicker: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.tintColor = .blue
        return pickerView
    }()
    
    var viewModel: AddListViewModel
    
    init(viewModel: AddListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        convifureView()
    }
}

extension AddListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return ListColor.allCases.count
        } else {
            return ListIcon.allCases.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        view.layer.cornerRadius = 21
        if component == 0 {
            view.backgroundColor = ListColor.allCases[row].hexColor.hexStringToUIColor()
            return view
        } else {
            view.backgroundColor = "#E5E5E5".hexStringToUIColor()
            let imageView = UIImageView(image: UIImage(named: ListIcon.allCases[row].iconName))
            imageView.frame = CGRect(x: 5, y: 5, width: 32, height: 32)
            view.addSubview(imageView)
            return view
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1 {
            viewModel.pickerSelection.icon = ListIcon.allCases[row].rawValue
        } else {
            viewModel.pickerSelection.color = ListColor.allCases[row].rawValue
        }
    }
}

extension AddListViewController {
    
    private func convifureView() {
        view.backgroundColor = .systemBackground
        title = "Добавить список"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(cancelAddingTouched))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(addListTouched))
        let views = [nameTextField, colorLabel, colorPicker]
        view.addSubviews(views)
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            colorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            colorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            colorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            colorPicker.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 10),
            colorPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            colorPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            colorPicker.bottomAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc
    private func cancelAddingTouched() {
        viewModel.cancelAdding()
    }
    
    @objc
    private func addListTouched() {
        viewModel.createNewList(name: nameTextField.text)
    }
}
