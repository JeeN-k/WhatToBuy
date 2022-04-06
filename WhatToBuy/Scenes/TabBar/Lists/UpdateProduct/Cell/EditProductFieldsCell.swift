//
//  EditProductFieldsCell.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 01.04.2022.
//

import UIKit

enum EditProductCellType: String {
    case count = "Кол-во"
    case price = "Цена"
    case note = "Заметка"
}

final class EditProductFieldsCell: UITableViewCell {
    
    private lazy var nameLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.isHidden = true
        stepper.setDecrementImage(stepper.decrementImage(for: .normal), for: .normal)
        stepper.setIncrementImage(stepper.incrementImage(for: .normal), for: .normal)
        stepper.maximumValue = 1000
        stepper.minimumValue = 0
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        return stepper
    }()
    
    var viewModel: EditProductCellViewModel?
    var cellType: EditProductCellType?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    func setupCell(type cellType: EditProductCellType) {
        self.cellType = cellType
        nameLable.text = cellType.rawValue
        
        switch cellType {
        case .count:
            stepper.isHidden = false
            textField.isEnabled = false
            stepper.value = Double(viewModel?.product.count ?? 0)
            textField.text = "\(viewModel?.product.count ?? 0)"
        case .price:
            textField.keyboardType = .decimalPad
            textField.placeholder = cellType.rawValue
            if let price = viewModel?.product.price {
                textField.text = "\(price)"
            }
        case .note:
            textField.keyboardType = .default
            textField.placeholder = cellType.rawValue
            textField.text = viewModel?.product.note
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textField.isEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EditProductFieldsCell {
    private func configureCell() {
        selectionStyle = .none
        contentView.addSubviews([nameLable, textField, stepper])
        
        NSLayoutConstraint.activate([
            nameLable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17),
            nameLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            stepper.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stepper.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            stepper.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            stepper.widthAnchor.constraint(equalToConstant: 90),
            
            textField.leadingAnchor.constraint(equalTo: nameLable.trailingAnchor, constant: 20),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17),
            textField.trailingAnchor.constraint(lessThanOrEqualTo: stepper.leadingAnchor, constant: -19)
        ])
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 16, y: 59, width: UIScreen.main.bounds.maxX - 16, height: 1.0)
        bottomBorder.backgroundColor = UIColor(white: 0.8, alpha: 1.0).cgColor
        contentView.layer.addSublayer(bottomBorder)
    }
    
    @objc
    private func stepperValueChanged() {
        let stepperValue = Int(stepper.value).description
        textField.text = stepperValue
        valueChanged(with: stepperValue)
    }
    
    @objc
    private func textFieldChanged() {
        valueChanged(with: textField.text)
    }
    
    private func valueChanged(with value: String?) {
        guard let cellType = cellType else { return }
        viewModel?.properyChanged(with: value, type: cellType)
    }
}
