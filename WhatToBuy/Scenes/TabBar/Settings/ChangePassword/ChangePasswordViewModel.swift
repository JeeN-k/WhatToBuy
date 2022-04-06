//
//  ChangePasswordViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 06.04.2022.
//

import Foundation

final class ChangePasswordViewModel {
    private let dataProvider: DataProviderProtocol
    var didSentEventClosure: ((ChangePasswordViewModel.Event) -> ())?
    
    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }
    
    func changePassword(oldPassword: String,
                        newPassword: String,
                        repeatPassword: String,
                        completion: @escaping((String) -> ())) {
        guard newPassword == repeatPassword else {
            completion("Пароли не совпадают")
            return
        }
        
        dataProvider.changeUserPassword(oldPassword: oldPassword, newPassword: newPassword) { [weak self] response in
            guard let self = self, let response = response else { return }
            if !response.success {
                completion(response.message)
            } else {
                self.didSentEventClosure?(.successfullyChanged)
            }
        }
    }
}

extension ChangePasswordViewModel {
    enum Event {
        case successfullyChanged
    }
}
