//
//  SwitchSettingCell.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 04.04.2022.
//

import Foundation
import UIKit

final class SwitchSettingCell: UITableViewCell {
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "gear")
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Some setting"
        return label
    }()
    
    private lazy var offlineModeSwitch: UISwitch = {
        let switcher = UISwitch()
        switcher.addTarget(self, action: #selector(switchChangeValue), for: .valueChanged)
        return switcher
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .secondarySystemBackground
        selectionStyle = .none
    }
    
    var didSwitchChangeAction: ((Bool) -> ())?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubviews([iconImageView, titleLabel, offlineModeSwitch])
        
        let sizeImage = contentView.frame.height - 14
        iconImageView.frame = CGRect(x: 16, y: 7, width: sizeImage, height: sizeImage)
        offlineModeSwitch.sizeToFit()
        offlineModeSwitch.frame = CGRect(x: contentView.frame.maxX - offlineModeSwitch.frame.size.width - 16,
                                         y: (contentView.frame.height - offlineModeSwitch.frame.height) / 2,
                                         width: offlineModeSwitch.frame.size.width,
                                         height: offlineModeSwitch.frame.size.height)
        
        titleLabel.frame = CGRect(x: iconImageView.frame.maxX + 8,
                                  y: contentView.frame.midY - 10,
                                  width: contentView.frame.width - sizeImage - 8 - 16,
                                  height: 20)
    }
}

extension SwitchSettingCell {
    func configureCell(from model: SettingsSwitchOption) {
        titleLabel.text = model.title
        iconImageView.image = UIImage(systemName: model.iconName)
        offlineModeSwitch.isOn = model.isOn
    }
    
    @objc
    private func switchChangeValue() {
        didSwitchChangeAction?(offlineModeSwitch.isOn)
    }
}
