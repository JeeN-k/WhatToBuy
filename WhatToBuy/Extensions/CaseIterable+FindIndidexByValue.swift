//
//  CaseIterable+FindIndidexByValue.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 01.04.2022.
//

import Foundation

extension CaseIterable where Self: Equatable {

    var index: Self.AllCases.Index? {
        return Self.allCases.firstIndex { self == $0 }
    }
}
