//
//  NewProductCellView.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 27.03.2022.
//

import UIKit

final class NewProductCellView: UITableViewCell {
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .light)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemIndigo.cgColor
        button.layer.cornerRadius = 14
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "Test product"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var viewModel: NewProductCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            nameLabel.text = viewModel.name
            if viewModel.isAdded {
                plusButton.backgroundColor = .systemIndigo
                plusButton.setTitleColor(.white, for: .normal)
            } else {
                plusButton.backgroundColor = .clear
                plusButton.setTitleColor(.systemIndigo, for: .normal)
            }
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

extension NewProductCellView {
    private func configureCell() {
        contentView.addSubviews([plusButton, nameLabel])
        
        NSLayoutConstraint.activate([
            plusButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            plusButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            plusButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            plusButton.widthAnchor.constraint(equalToConstant: 28),
            
            nameLabel.leadingAnchor.constraint(equalTo: plusButton.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
