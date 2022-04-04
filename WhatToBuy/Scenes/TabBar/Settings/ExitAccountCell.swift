//
//  ExitAccountCell.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 04.04.2022.
//

import UIKit

final class ExitAccountCell: UITableViewCell {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Выйти"
        label.textColor = .systemRed
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(label)
        label.sizeToFit()
        label.center = contentView.center
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
