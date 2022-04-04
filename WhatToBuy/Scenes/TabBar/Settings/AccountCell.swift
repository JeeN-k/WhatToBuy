//
//  AccountCell.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 04.04.2022.
//

import UIKit

final class AccountCell: UITableViewCell {
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.text = "My Name"
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "example@mail.ru"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        separatorInset = .zero
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubviews([cardView, nameLabel, emailLabel])
        
        cardView.frame = CGRect(x: 16, y: 5, width: contentView.frame.width - 32, height: contentView.frame.height - 10)
        nameLabel.frame = CGRect(x: cardView.frame.minX + 16,
                                 y: cardView.frame.minY + 10,
                                 width: cardView.frame.width - 32,
                                 height: 20)
        emailLabel.frame = CGRect(x: cardView.frame.minX + 16,
                                  y: nameLabel.frame.maxY + 10,
                                  width: nameLabel.frame.width,
                                  height: 20)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AccountCell {
    func configureCell(from model: SettingsAccount) {
        nameLabel.text = model.name
        emailLabel.text = model.email
    }
}
