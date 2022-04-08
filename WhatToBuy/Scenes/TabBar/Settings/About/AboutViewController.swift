//
//  AboutViewController.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 05.04.2022.
//

import UIKit

final class AboutViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let meme1 = MemeImageView(image: UIImage(named: "devDay"))
        let meme2 = MemeImageView(image: UIImage(named: "iosAndroid"))
        let meme3 = MemeImageView(image: UIImage(named: "junSen"))
        let meme4 = MemeImageView(image: UIImage(named: "iosMeme"))
        cardView.layer.cornerRadius = 12
        view.addSubview(scrollView)
        scrollView.addSubviews([cardView, meme1, meme2, meme3, meme4])
        cardView.addSubview(descriptionLabel)
        scrollView.frame = view.bounds
        
        let defaultImageSize = CGSize(width: view.frame.width - 32, height: view.frame.height / 3)
        let labelSize = descriptionLabel.sizeThatFits(CGSize(width: view.bounds.width - 48, height: 200))
        cardView.frame = CGRect(x: 16, y: 20, width: labelSize.width + 16, height: labelSize.height + 20)
        descriptionLabel.frame = CGRect(x: 8, y: 10, width: labelSize.width, height: labelSize.height)
        meme1.frame = CGRect(x: 16, y: cardView.frame.maxY + 30,
                             width: defaultImageSize.width,
                             height: defaultImageSize.height)
        meme2.frame = CGRect(x: 16, y: meme1.frame.maxY + 30,
                             width: defaultImageSize.width,
                             height: defaultImageSize.height)
        meme3.frame = CGRect(x: 16, y: meme2.frame.maxY + 30,
                             width: defaultImageSize.width,
                             height: defaultImageSize.height)
        meme4.frame = CGRect(x: 16, y: meme3.frame.maxY + 30,
                             width: defaultImageSize.width,
                             height: defaultImageSize.height)
        
        let scrollViewHeight = cardView.frame.height + 20 + (30 * 4) + (defaultImageSize.height * 4)
        scrollView.contentSize = CGSize(width: view.frame.width, height: scrollViewHeight)
    }
}

extension AboutViewController {
    private func configureView() {
        title = "О приложении"
        view.backgroundColor = .systemBackground
        descriptionLabel.text = "Вы правда хотели прочитать что-то об этом приложении? Но зачем? Чтобы узнать версию? Или почту разработчика? Не нужно вам это. Лучше полистайте мемы с помощью внедренного мною SCROLLVIEW!"
    }
}
