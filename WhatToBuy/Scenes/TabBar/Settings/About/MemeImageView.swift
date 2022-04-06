//
//  MemeImageView.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 06.04.2022.
//

import Foundation
import UIKit

final class MemeImageView: UIImageView {
    
    override init(image: UIImage?) {
        super.init(image: image)
        layer.cornerRadius = 12
        contentMode = .scaleToFill
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
