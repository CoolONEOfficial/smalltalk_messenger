//
//  FirestoreCodableInterfaces.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 11.03.2020.
//

import Foundation
import CodableFirebase
import Firebase

extension DocumentReference: DocumentReferenceType {}
extension GeoPoint: GeoPointType {}
extension FieldValue: FieldValueType {}
extension Timestamp: TimestampType {}
