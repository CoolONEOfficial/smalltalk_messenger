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

extension Timestamp {
    static func decodeTimestamp<T: CodingKey>(from container: KeyedDecodingContainer<T>, forKey key: T) -> Timestamp {
        if let dict = try? container.decode([String: Int64].self, forKey: key) {
            return Timestamp.init(
                seconds: dict["_seconds"]!,
                nanoseconds: Int32(exactly: dict["_nanoseconds"]!)!
            )
        }
        
        return try! container.decode(Timestamp.self, forKey: key)
    }
}
