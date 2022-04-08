//
//  EditListView.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 01.04.2022.
//

import UIKit

enum ListEditType {
    case edit
    case new
}

class EditListView: UIView {
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 22)
        textField.placeholder = "Название"
        textField.addTarget(self, action: #selector(nameTextChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var colorLabel: UILabel = {
        let label = UILabel()
        label.text = "Внешний вид"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var iconPicker: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.tintColor = .blue
        return pickerView
    }()
    
    var didTextChanged: ((Bool) -> Void)?
    
    var viewModel: EditableList
    
    init(viewModel: EditableList) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        convifureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EditListView: UIPickerViewDelegate, UIPickerViewDataSource {
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

extension EditListView {
    func convifureView() {
        backgroundColor = .systemBackground
        
        let views = [nameTextField, colorLabel, iconPicker]
        addSubviews(views)
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            colorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            colorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            colorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            iconPicker.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 10),
            iconPicker.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconPicker.trailingAnchor.constraint(equalTo: trailingAnchor),
            iconPicker.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 50)
        ])
    }
    
    @objc
    func nameTextChanged() {
        let isTextEmpty = nameTextField.text == ""
        didTextChanged?(isTextEmpty)
    }
}
