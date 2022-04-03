//
//  WelcomeViewController.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 21.03.2022.
//

import UIKit

class WelcomeViewController: UIViewController {
    var viewModel: WelcomeViewModel!
    
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.text = "Добро пожаловать в WhatToBuy"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private lazy var welcomeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.text = "Правильный способ сделать поход за покупками проще"
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private lazy var benefitTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.text = "Сохраните энергию и время для других вещей"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var benefitTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.text = "Сделайте поход за покупками умнее, забудьте про дополнительные походы в супермаркеты и торговые центры. Организуйте свое время с WhatToBuy"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemIndigo.withAlphaComponent(0.7)
        button.addTarget(self, action: #selector(signInTouched), for: .touchUpInside)
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Зарегистрироваться", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signUpTouched), for: .touchUpInside)
        button.backgroundColor = .systemIndigo.withAlphaComponent(0.7)
        return button
    }()
    
    private lazy var missAuthButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Пропустить авторизацию", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemIndigo.withAlphaComponent(0.7)
        button.addTarget(self, action: #selector(missSignInTouched), for: .touchUpInside)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        setGradientBackground()
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}

extension WelcomeViewController {
    private func configureView() {
        
        view.backgroundColor = .systemTeal
        let views = [welcomeLabel, welcomeTitleLabel, benefitTextLabel, benefitTitleLabel, signInButton, signUpButton, missAuthButton]
        view.addSubviews(views)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            welcomeTitleLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 4),
            welcomeTitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            welcomeTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            welcomeTitleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            missAuthButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            missAuthButton.heightAnchor.constraint(equalToConstant: 50),
            missAuthButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            missAuthButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            signInButton.bottomAnchor.constraint(equalTo: missAuthButton.topAnchor, constant: -20),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signUpButton.bottomAnchor.constraint(equalTo: signInButton.bottomAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),
            
            benefitTextLabel.bottomAnchor.constraint(equalTo: signInButton.topAnchor, constant: -10),
            benefitTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            benefitTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            benefitTitleLabel.bottomAnchor.constraint(equalTo: benefitTextLabel.topAnchor, constant: -8),
            benefitTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            benefitTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    private func setGradientBackground() {
        let colorTop = UIColor.systemTeal.cgColor
        let colorBottom = UIColor.systemBlue.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @objc
    private func signInTouched() {
        viewModel.goToLogin()
    }
    
    @objc
    private func signUpTouched() {
        viewModel.goToRegister()
    }
    
    @objc
    private func missSignInTouched() {
        viewModel.missAuth()
    }
}



