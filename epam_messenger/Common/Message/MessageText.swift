//
//  MessageText.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 22.03.2020.
//

import Foundation

protocol MessageTextProtocol: MessageProtocol {
    func kindText(at: Int) -> String?
}
