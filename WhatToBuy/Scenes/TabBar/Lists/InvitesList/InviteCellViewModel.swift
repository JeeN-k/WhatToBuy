//
//  InviteCellViewModel.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 02.04.2022.
//

import Foundation

protocol InviteDelegate {
    func acceptInvite(listId: String)
    func refuseInvite(listId: String)
}

final class InviteCellViewModel {
    let invite: Invite
    let delegate: InviteDelegate
    
    init(invite: Invite, delegate: InviteDelegate) {
        self.invite = invite
        self.delegate = delegate
    }
    
    func acceptInvite() {
        delegate.acceptInvite(listId: invite.id)
    }
    
    func refuseInvite() {
        delegate.refuseInvite(listId: invite.id)
    }
}
