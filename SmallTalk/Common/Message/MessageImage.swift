//
//  MessageImage.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 22.03.2020.
//

import UIKit

protocol MessageImageProtocol: MessageProtocol {
    func kindImage(at: Int) -> (path: String, size: ImageSize)?
}
