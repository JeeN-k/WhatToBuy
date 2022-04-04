//
//  SettingCell.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 04.04.2022.
//

import UIKit

final class SettingCell: UITableViewCell {
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "gear")
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Some setting"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .secondarySystemBackground
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubviews([iconImageView, titleLabel])
        
        let sizeImage = contentView.frame.height - 14
        iconImageView.frame = CGRect(x: 16, y: 7, width: sizeImage, height: sizeImage)
        
        titleLabel.frame = CGRect(x: iconImageView.frame.maxX + 8,
                                  y: contentView.frame.midY - 10,
                                  width: contentView.frame.width - sizeImage - 8 - 16,
                                  height: 20)
    }
}

extension SettingCell {
    func configureCell(from model: SettingsOption) {
        titleLabel.text = model.title
        iconImageView.image = UIImage(systemName: model.iconName)
    }
}
