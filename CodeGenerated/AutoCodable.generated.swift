// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


extension MessageModel {

    enum CodingKeys: String, CodingKey {
        case documentId
        case text
        case userId
        case timestamp
    }

    internal init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        documentId = try container.decode(String.self, forKey: .documentId)
        text = try container.decode(String.self, forKey: .text)
        userId = try container.decode(Int.self, forKey: .userId)
        timestamp = MessageModel.decodeTimestamp(from: container)
    }

}
