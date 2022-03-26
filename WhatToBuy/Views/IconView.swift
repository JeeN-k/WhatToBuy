//
//  IconView.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 24.03.2022.
//

import UIKit

final class IconView: UIView {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 5, y: 5, width: 32, height: 32)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(image: String, color: String) {
        addSubview(imageView)
        layer.cornerRadius = 21
        imageView.image = UIImage(named: image)
        backgroundColor = color.hexStringToUIColor()
    }
}
