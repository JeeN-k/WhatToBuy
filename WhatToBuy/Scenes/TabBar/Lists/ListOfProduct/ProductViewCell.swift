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
            guard let viewModel = viewModel else { return }
            titleLabel.text = viewModel.name
            noteLabel.text = viewModel.note
            if let count = viewModel.count, count != 0 {
                countLabel.isHidden = false
                countLabel.text = "\(count) шт"
            }
            if let price = viewModel.price, price != 0 {
                priceLabel.isHidden = false
                priceLabel.text = "\(price) P"
            }
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
        let views = [titleLabel, noteLabel, countLabel, priceLabel]
        contentView.addSubviews(views)
        
        NSLayoutConstraint.activate([
            countLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            countLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            priceLabel.trailingAnchor.constraint(equalTo: countLabel.leadingAnchor, constant: -28),
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -5),
            
            noteLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            noteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
}
