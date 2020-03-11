// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


extension MessageModel {

    enum CodingKeys: String, CodingKey {
        case documentId
        case text
        case userId
        case timestamp
    }

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(text, forKey: .text)
        try container.encode(userId, forKey: .userId)
        try container.encode(timestamp, forKey: .timestamp)
    }

}
