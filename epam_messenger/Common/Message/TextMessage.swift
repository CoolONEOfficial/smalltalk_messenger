//
//  TextMessage.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 15.03.2020.
//

import Foundation

protocol TextMessageProtocol: MessageProtocol {
    var text: String { get }
}
