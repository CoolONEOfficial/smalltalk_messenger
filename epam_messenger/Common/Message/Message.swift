//
//  Message.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 15.03.2020.
//

import Foundation

protocol MessageProtocol {
    var isIncoming: Bool { get }
    var date: Date { get }
    var userId: Int { get }
    var documentId: String { get }
}
