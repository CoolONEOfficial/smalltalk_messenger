//
//  Date.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 15.03.2020.
//

import Foundation

extension Date {
    var midnight: Date {
        return Calendar(identifier: .gregorian).startOfDay(for: self)
    }
}
