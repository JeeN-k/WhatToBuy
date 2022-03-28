//
//  SignUpViewController.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 21.03.2022.
//

import UIKit

class SignUpViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.text = "Создать новый аккаунт"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.placeholder = "Имя"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(white: 1, alpha: 0.5)
        textField.setLeftPaddingPoints(12)
        textField.layer.cornerRadius = 10
        textField.delegate = self
        textField.returnKeyType = .next
        textField.addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
        return textField
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
        textField.addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
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
        textField.addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
        return textField
    }()

    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать аккаунт", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.systemGray, for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signUpTouched), for: .touchUpInside)
        button.backgroundColor = .white
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()
    
    private lazy var hintLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.text = "Уже зарегистрированы?"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signInTouched), for: .touchUpInside)
        return button
    }()
    
    let viewModel: SignUpViewModelProtocol
    
    init(viewModel: SignUpViewModelProtocol) {
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
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            signUpTouched()
        }
        return true
    }
}

extension SignUpViewController {
    func configureView() {
        
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .systemBlue
        let views = [titleLabel, nameTextField, emailTextField, passwordTextField, signUpButton, hintLabel, signInButton]
        view.addSubviews(views)
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 45),
            
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 45),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 45),
            
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            signUpButton.heightAnchor.constraint(equalToConstant: 55),
            
            hintLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 15),
            hintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
            hintLabel.heightAnchor.constraint(equalToConstant: 20),
            
            signInButton.topAnchor.constraint(equalTo: hintLabel.topAnchor),
            signInButton.leadingAnchor.constraint(equalTo: hintLabel.trailingAnchor, constant: 5),
            signInButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    @objc
    private func signInTouched() {
        viewModel.goToSignIn()
    }
    
    @objc
    private func signUpTouched() {
        guard let name = nameTextField.text,
                let password = passwordTextField.text,
                let email = emailTextField.text else { return }
        viewModel.signUpUser(name: name, password: password, email: email) { [weak self] message in
            self?.showAlertWith(text: message)
        }
    }
    
    @objc
    private func textFieldTextChanged() {
        if nameTextField.text == "" || emailTextField.text == "" || passwordTextField.text == "" {
            signUpButton.isEnabled = false
            signUpButton.alpha = 0.5
        } else {
            signUpButton.isEnabled = true
            signUpButton.alpha = 1
        }
    }
}

