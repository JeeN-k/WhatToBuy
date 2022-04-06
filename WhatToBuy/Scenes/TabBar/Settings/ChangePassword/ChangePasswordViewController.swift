//
//  ChangePasswordViewController.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 06.04.2022.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.text = "Изменение пароля"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var oldPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.placeholder = "Старый пароль"
        textField.backgroundColor = UIColor(white: 1, alpha: 0.5)
        textField.setLeftPaddingPoints(12)
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 10
        textField.delegate = self
        textField.returnKeyType = .next
        textField.addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var newPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.placeholder = "Новый пароль"
        textField.backgroundColor = UIColor(white: 1, alpha: 0.5)
        textField.setLeftPaddingPoints(12)
        textField.layer.cornerRadius = 10
        textField.isSecureTextEntry = true
        textField.delegate = self
        textField.returnKeyType = .next
        textField.addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var repeatNewPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.placeholder = "Повторите пароль"
        textField.backgroundColor = UIColor(white: 1, alpha: 0.5)
        textField.setLeftPaddingPoints(12)
        textField.layer.cornerRadius = 10
        textField.isSecureTextEntry = true
        textField.delegate = self
        textField.returnKeyType = .done
        textField.addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var changePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Изменить пароль", for: .normal)
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
    
    let viewModel: ChangePasswordViewModel
    
    init(viewModel: ChangePasswordViewModel) {
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
        oldPasswordTextField.frame = CGRect(x: 16,
                                     y: titleLabel.frame.maxY + 20,
                                     width: view.frame.width - 32,
                                     height: 46)
        newPasswordTextField.frame = CGRect(x: 16,
                                      y: oldPasswordTextField.frame.maxY + 8,
                                      width: view.frame.width - 32,
                                      height: 46)
        repeatNewPasswordTextField.frame = CGRect(x: 16,
                                         y: newPasswordTextField.frame.maxY + 8,
                                         width: view.frame.width - 32,
                                         height: 46)
        changePasswordButton.frame = CGRect(x: 16,
                                    y: repeatNewPasswordTextField.frame.maxY + 16,
                                    width: view.frame.width - 32,
                                    height: 50)
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == oldPasswordTextField {
            newPasswordTextField.becomeFirstResponder()
        } else if textField == newPasswordTextField {
            repeatNewPasswordTextField.becomeFirstResponder()
        } else if textField == repeatNewPasswordTextField {
            repeatNewPasswordTextField.resignFirstResponder()
            signUpTouched()
        }
        return true
    }
}

extension ChangePasswordViewController {
    func configureView() {
        
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .systemBlue
        let views = [titleLabel, oldPasswordTextField,
                     newPasswordTextField, repeatNewPasswordTextField, changePasswordButton]
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
        let bottomOfButton = changePasswordButton.convert(changePasswordButton.bounds,
                                                          to: self.view).maxY
        let topOfKeyboard = view.frame.height - keyboardFrame.height
        if bottomOfButton > topOfKeyboard {
            shouldMoveViewUp = true
        }
        
        if shouldMoveViewUp {
            self.view.frame.origin.y = 0 - (bottomOfButton - topOfKeyboard)
        }
    }
    
    @objc
    private func keyboardHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    @objc
    private func signUpTouched() {
        guard let oldPassword = oldPasswordTextField.text,
              let newPassword = newPasswordTextField.text,
              let repeatPassword = repeatNewPasswordTextField.text else { return }
        view.activityStartAnimating(backgroundColor: .systemGray.withAlphaComponent(0.3))
        viewModel.changePassword(oldPassword: oldPassword,
                                 newPassword: newPassword,
                                 repeatPassword: repeatPassword) { [weak self] error in
            self?.view.activityStopAnimating()
            self?.showAlertWith(text: error)
        }
    }
    
    @objc
    private func textFieldTextChanged() {
        if (oldPasswordTextField.text == "" || newPasswordTextField.text == ""
            || repeatNewPasswordTextField.text == ""){
            changePasswordButton.isEnabled = false
            changePasswordButton.alpha = 0.5
        } else {
            changePasswordButton.isEnabled = true
            changePasswordButton.alpha = 1
        }
    }
}
