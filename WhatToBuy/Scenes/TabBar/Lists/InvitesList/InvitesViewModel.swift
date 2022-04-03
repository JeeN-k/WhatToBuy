//
//  InvitesViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 02.04.2022.
//

import Foundation

protocol InvitesViewModelProtocol {
    var invites: Observable<[Invite]> { get }
    func fetchInvites()
    func numberOfItems() -> Int
    func viewModelForCell(at indexPath: IndexPath) -> InviteCellViewModel
}

final class InvitesViewModel: InvitesViewModelProtocol {
    let dataProvider: DataProviderProtocol
    var invites: Observable<[Invite]> = Observable([])
    
    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }
    
    func fetchInvites() {
        dataProvider.fetchUserInvites { [weak self] invites in
            guard let invites = invites, let self = self else { return }
            self.invites.value = invites
        }
    }
    
    func numberOfItems() -> Int {
        return invites.value.count
    }
    
    func viewModelForCell(at indexPath: IndexPath) -> InviteCellViewModel {
        let invite = invites.value[indexPath.row]
        return InviteCellViewModel(invite: invite, delegate: self)
    }
}

extension InvitesViewModel: InviteDelegate {
    func acceptInvite(listId: String) {
        let index = invites.value.firstIndex(where: { $0.id == listId })
        if let index = index {
            invites.value.remove(at: index)
        }
        dataProvider.answerToInvite(answerType: .accept, listId: listId)
    }
    
    func refuseInvite(listId: String) {
        let index = invites.value.firstIndex(where: { $0.id == listId })
        if let index = index {
            invites.value.remove(at: index)
        }
        dataProvider.answerToInvite(answerType: .refuse, listId: listId)
    }
}
