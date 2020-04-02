//
//  SourceryInterfaces.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 10.03.2020.
//

import Foundation

protocol AutoDecodable: Decodable {}
protocol AutoEncodable: Encodable {}
protocol AutoCodable: AutoDecodable, AutoEncodable {}
protocol AutoEquatable {}
