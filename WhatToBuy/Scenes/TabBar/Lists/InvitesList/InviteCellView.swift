//
//  InviteCellView.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 02.04.2022.
//

import UIKit

final class InviteCellView: UITableViewCell {
    private lazy var listNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Some list name"
        return label
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "От: example@gmail.com"
        return label
    }()
    
    private lazy var acceptButton: UIButton = {
        var filled = UIButton.Configuration.filled()
        filled.image = UIImage(systemName: "checkmark")
        filled.baseBackgroundColor = .systemGreen
        filled.imagePlacement = .all
        let button = UIButton(configuration: filled)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(acceptTouched), for: .touchUpInside)
        return button
    }()
    
    private lazy var refuseButton: UIButton = {
        var filled = UIButton.Configuration.filled()
        filled.image = UIImage(systemName: "xmark")
        filled.baseBackgroundColor = .systemRed
        filled.imagePlacement = .all
        let button = UIButton(configuration: filled)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(refuseTouched), for: .touchUpInside)
        return button
    }()
    
    var viewModel: InviteCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            listNameLabel.text = viewModel.invite.name
            userNameLabel.text = "От: \(viewModel.invite.userName)"
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

extension InviteCellView {
    private func configureView() {
        selectionStyle = .none
        contentView.addSubviews([listNameLabel, userNameLabel, acceptButton, refuseButton])
        
        NSLayoutConstraint.activate([
            listNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            listNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            userNameLabel.topAnchor.constraint(equalTo: listNameLabel.bottomAnchor, constant: 5),
            userNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            acceptButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            acceptButton.widthAnchor.constraint(equalToConstant: 40),
            acceptButton.heightAnchor.constraint(equalToConstant: 40),
            acceptButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            refuseButton.trailingAnchor.constraint(equalTo: acceptButton.leadingAnchor, constant: -15),
            refuseButton.widthAnchor.constraint(equalToConstant: 40),
            refuseButton.heightAnchor.constraint(equalToConstant: 40),
            refuseButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    @objc
    private func acceptTouched() {
        viewModel?.acceptInvite()
    }
    
    @objc
    private func refuseTouched() {
        viewModel?.refuseInvite()
    }
}
