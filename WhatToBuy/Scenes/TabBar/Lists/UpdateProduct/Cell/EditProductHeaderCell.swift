//
//  EditProductHeaderCell.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 01.04.2022.
//

import UIKit

protocol HeaderEditedDelegate {
    func productNameEdited(name: String?)
}

final class EditProductHeaderCell: UITableViewCell {
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Название"
        textField.textColor = .white
        textField.setLeftPaddingPoints(16)
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        return textField
    }()
    
    var delegate: HeaderEditedDelegate?
    
    var viewModel: EditProductCellViewModel? {
        didSet {
            textField.text = viewModel?.product.name
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EditProductHeaderCell {
    private func configureCell() {
        backgroundColor = .systemIndigo
        selectionStyle = .none
        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    @objc
    private func textFieldChanged() {
        guard let delegate = delegate else { return }
        delegate.productNameEdited(name: textField.text)
    }
}
