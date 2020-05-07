//
//  ChatListForwardDelegate.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 29.03.2020.
//

import Foundation

protocol ChatListForwardDelegate {
    func didSelectChat(_ chat: ChatModel)
}
