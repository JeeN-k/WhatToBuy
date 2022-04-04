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
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.placeholder = "Имя"
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
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать аккаунт", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.systemGray, for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.layer.cornerRadius = 10
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
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let titleSize = titleLabel.sizeThatFits(CGSize(width: view.frame.width - 32, height: 999))
        titleLabel.frame = CGRect(x: (view.frame.width - titleSize.width) / 2,
                                  y: view.frame.midY / 2,
                                  width: titleSize.width,
                                  height: titleSize.height)
        nameTextField.frame = CGRect(x: 16,
                                     y: titleLabel.frame.maxY + 20,
                                     width: view.frame.width - 32,
                                     height: 46)
        emailTextField.frame = CGRect(x: 16,
                                      y: nameTextField.frame.maxY + 8,
                                      width: view.frame.width - 32,
                                      height: 46)
        passwordTextField.frame = CGRect(x: 16,
                                         y: emailTextField.frame.maxY + 8,
                                         width: view.frame.width - 32,
                                         height: 46)
        signUpButton.frame = CGRect(x: 16,
                                    y: passwordTextField.frame.maxY + 16,
                                    width: view.frame.width - 32,
                                    height: 50)
        hintLabel.sizeToFit()
        signInButton.sizeToFit()
        hintLabel.frame = CGRect(x: (view.frame.width - hintLabel.frame.width - signInButton.frame.width)/2,
                                 y: signUpButton.frame.maxY + 16,
                                 width: hintLabel.frame.size.width,
                                 height: hintLabel.frame.size.height)
        signInButton.frame = CGRect(x: hintLabel.frame.maxX + 5,
                                    y: signUpButton.frame.maxY + 10,
                                    width: signInButton.frame.size.width,
                                    height: signInButton.frame.size.height)
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
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc
    private func keyboardShow(notification: NSNotification) {
        guard let keyboardFrame =
                (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as?  NSValue)?.cgRectValue else {
            return
        }
        var shouldMoveViewUp = false
        let bottomOfHintLabel = hintLabel.convert(hintLabel.bounds, to: self.view).maxY
        let topOfKeyboard = view.frame.height - keyboardFrame.height
        if bottomOfHintLabel > topOfKeyboard {
            shouldMoveViewUp = true
        }
        
        if shouldMoveViewUp {
            self.view.frame.origin.y = 0 - (bottomOfHintLabel - topOfKeyboard)
        }
    }
    
    @objc
    private func keyboardHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
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
        view.activityStartAnimating(backgroundColor: .systemGray.withAlphaComponent(0.3))
        viewModel.signUpUser(name: name, password: password, email: email) { [weak self] message in
            self?.view.activityStopAnimating()
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

