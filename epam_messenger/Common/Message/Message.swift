//
//  Message.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 15.03.2020.
//

import UIKit

protocol MessageProtocol {
    var isIncoming: Bool { get }
    var textColor: UIColor { get }
    var backgroundColor: UIColor { get }
    
    var date: Date { get }
    var userId: String { get }
    var documentId: String? { get }
    var kind: [MessageModel.MessageKind] { get }
    
    func forwardedKind(_ userId: String) -> [MessageModel.MessageKind]
}
