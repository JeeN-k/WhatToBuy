//
//  ProductViewCell.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 25.03.2022.
//

import UIKit

final class ProductViewCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "TestProduct"
        return label
    }()
    
    private lazy var noteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.text = "TestCategory"
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "5"
        label.isHidden = true
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.text = "120P"
        label.isHidden = true
        return label
    }()
    
    var viewModel: ProductCellViewModel? {
        didSet {
            setupCell()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProductViewCell {
    
    private func configureView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, noteLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        let views = [stackView, countLabel, priceLabel]
        contentView.addSubviews(views)
        
        NSLayoutConstraint.activate([
            countLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            countLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            priceLabel.trailingAnchor.constraint(equalTo: countLabel.leadingAnchor, constant: -28),
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: priceLabel.leadingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 16, y: 55, width: UIScreen.main.bounds.maxX - 16, height: 1)
        bottomBorder.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2).cgColor
        contentView.layer.addSublayer(bottomBorder)
    }
    
    private func setupCell() {
        guard let viewModel = viewModel else { return }
        if viewModel.isBought {
            titleLabel.textColor = .systemGray
            countLabel.textColor = .systemGray
        } else {
            titleLabel.textColor = .label
            countLabel.textColor = .label
        }
        
        titleLabel.text = viewModel.name
        if let note = viewModel.note, note != "" {
            noteLabel.text = viewModel.note
            noteLabel.isHidden = false
        } else {
            noteLabel.isHidden = true
        }
        if let count = viewModel.count, count != 0 {
            countLabel.isHidden = false
            countLabel.text = "\(count) ????"
        } else {
            countLabel.isHidden = true
        }
        if let price = viewModel.price, price != 0 {
            priceLabel.isHidden = false
            priceLabel.text = "\(price) P"
        } else {
            priceLabel.isHidden = true
        }
    }
}
