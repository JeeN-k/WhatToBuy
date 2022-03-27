//
//  SignInViewController.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 21.03.2022.
//

import UIKit

class SignInViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.text = "Войти в аккаунт"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.placeholder = "Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(white: 1, alpha: 0.5)
        textField.setLeftPaddingPoints(12)
        textField.layer.cornerRadius = 10
        textField.keyboardType = .emailAddress
        textField.delegate = self
        textField.returnKeyType = .next
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.placeholder = "Пароль"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(white: 1, alpha: 0.5)
        textField.setLeftPaddingPoints(12)
        textField.layer.cornerRadius = 10
        textField.isSecureTextEntry = true
        textField.delegate = self
        textField.returnKeyType = .done
        return textField
    }()

    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var hintLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.text = "Еще нет аккаунта?"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        return button
    }()
    
    let viewModel: SignInViewModel
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            signInTapped()
        }
        return true
    }
}

extension SignInViewController {
    func configureView() {
        
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .systemBlue
        let views = [titleLabel, emailTextField, passwordTextField, signUpButton, hintLabel, signInButton]
        view.addSubviews(views)
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 45),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 45),
            
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            signInButton.heightAnchor.constraint(equalToConstant: 55),
            
            hintLabel.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 15),
            hintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
            hintLabel.heightAnchor.constraint(equalToConstant: 20),
            
            signUpButton.topAnchor.constraint(equalTo: hintLabel.topAnchor),
            signUpButton.leadingAnchor.constraint(equalTo: hintLabel.trailingAnchor, constant: 5),
            signUpButton.heightAnchor.constraint(equalToConstant: 20),
            
        ])
    }
    
    @objc
    private func signInTapped() {
        
        UIView.transition(with: passwordTextField, duration: 1, options: .transitionCrossDissolve) {
            self.passwordTextField.layer.borderWidth = 2
            self.passwordTextField.layer.borderColor = UIColor.systemRed.cgColor
        }

        print("ok")
    }
    
    @objc
    private func signUpTapped() {
        viewModel.goToRegister()
    }
}


