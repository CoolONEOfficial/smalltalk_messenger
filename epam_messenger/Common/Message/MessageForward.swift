//
//  MessageForward.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 29.03.2020.
//

import Foundation

protocol MessageForwardProtocol: MessageProtocol {
    func kindForwardUser(at: Int) -> String?
}
