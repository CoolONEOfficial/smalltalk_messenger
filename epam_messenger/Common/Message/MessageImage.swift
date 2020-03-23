//
//  MessageImage.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 22.03.2020.
//

import Foundation

protocol MessageImageProtocol: MessageProtocol {
    var image: (path: String, size: ImageSize)? { get }
}
