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
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.placeholder = "Email"
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
        textField.backgroundColor = UIColor(white: 1, alpha: 0.5)
        textField.setLeftPaddingPoints(12)
        textField.layer.cornerRadius = 10
        textField.isSecureTextEntry = true
        textField.delegate = self
        textField.returnKeyType = .done
        textField.addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
        return textField
    }()

    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.systemGray, for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.layer.cornerRadius = 10
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        button.alpha = 0.5
        button.isEnabled = false
        return button
    }()
    
    private lazy var hintLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.text = "Еще нет аккаунта?"
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        return button
    }()
    
    let viewModel: SignInViewModelProtocol
    
    init(viewModel: SignInViewModelProtocol) {
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: (view.frame.width - titleLabel.frame.width) / 2,
                                  y: view.frame.midY / 2,
                                  width: titleLabel.frame.size.width,
                                  height: titleLabel.frame.size.height)
        emailTextField.frame = CGRect(x: 16,
                                      y: titleLabel.frame.maxY + 20,
                                      width: view.frame.width - 32,
                                      height: 46)
        passwordTextField.frame = CGRect(x: 16,
                                      y: emailTextField.frame.maxY + 8,
                                      width: view.frame.width - 32,
                                      height: 46)
        signInButton.frame = CGRect(x: 16,
                                    y: passwordTextField.frame.maxY + 16,
                                    width: view.frame.width - 32,
                                    height: 50)
        hintLabel.sizeToFit()
        signUpButton.sizeToFit()
        hintLabel.frame = CGRect(x: (view.frame.width - hintLabel.frame.width - signUpButton.frame.width)/2,
                                 y: signInButton.frame.maxY + 16,
                                 width: hintLabel.frame.size.width,
                                 height: hintLabel.frame.size.height)
        signUpButton.frame = CGRect(x: hintLabel.frame.maxX + 5,
                                    y: signInButton.frame.maxY + 10,
                                    width: signUpButton.frame.size.width,
                                    height: signUpButton.frame.size.height)
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
        let views = [titleLabel, emailTextField, passwordTextField, signUpButton, hintLabel, signInButton]
        view.addSubviews(views)
        
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .systemBlue
    }
    
    @objc
    private func textFieldTextChanged() {
        if emailTextField.text == "" || passwordTextField.text == "" {
            signInButton.isEnabled = false
            signInButton.alpha = 0.5
        } else {
            signInButton.isEnabled = true
            signInButton.alpha = 1
        }
    }
    
    @objc
    private func signInTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        view.activityStartAnimating(backgroundColor: .gray.withAlphaComponent(0.5))
        viewModel.signIn(email: email, password: password) { [weak self] message in
            self?.view.activityStopAnimating()
            self?.showAlertWith(text: message)
        }
    }
    
    @objc
    private func signUpTapped() {
        viewModel.goToRegister()
    }
}


