//
//  SourceryInterfaces.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 10.03.2020.
//

import Foundation

public protocol AutoDecodable: Decodable {}
public protocol AutoEncodable: Encodable {}
public protocol AutoCodable: AutoDecodable, AutoEncodable {}
public protocol AutoEquatable {}
public protocol AutoMockable {}
