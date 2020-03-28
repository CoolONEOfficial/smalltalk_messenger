// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


extension ChatModel {

    enum CodingKeys: String, CodingKey {
        case documentId
        case users
        case name
        case lastMessage
    }

    internal init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        documentId = (try? container.decode(String.self, forKey: .documentId)) ?? ChatModel.defaultDocumentId
        users = try container.decode([Int].self, forKey: .users)
        name = try container.decode(String.self, forKey: .name)
        lastMessage = (try? container.decodeIfPresent(MessageModel.self, forKey: .lastMessage)) ?? ChatModel.defaultLastMessage
    }

}

extension MessageModel {

    internal init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        documentId = (try? container.decodeIfPresent(String.self, forKey: .documentId)) ?? MessageModel.defaultDocumentId
        kind = (try? container.decode([MessageKind].self, forKey: .kind)) ?? MessageModel.defaultKind
        userId = try container.decode(Int.self, forKey: .userId)
        timestamp = MessageModel.decodeTimestamp(from: container)
    }

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(documentId, forKey: .documentId)
        try container.encode(kind, forKey: .kind)
        try container.encode(userId, forKey: .userId)
        try container.encode(timestamp, forKey: .timestamp)
    }

}

extension MessageModel.MessageKind {

    enum CodingKeys: String, CodingKey {
        case text
        case image
        case audio
        case path
        case size
    }

    internal init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if container.allKeys.contains(.text), try container.decodeNil(forKey: .text) == false {
            var associatedValues = try container.nestedUnkeyedContainer(forKey: .text)
            let associatedValue0 = try associatedValues.decode(String.self)
            self = .text(associatedValue0)
            return
        }
        if container.allKeys.contains(.image), try container.decodeNil(forKey: .image) == false {
            let associatedValues = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .image)
            let path = try associatedValues.decode(String.self, forKey: .path)
            let size = try associatedValues.decode(ImageSize.self, forKey: .size)
            self = .image(path: path, size: size)
            return
        }
        if container.allKeys.contains(.audio), try container.decodeNil(forKey: .audio) == false {
            let associatedValues = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .audio)
            let path = try associatedValues.decode(String.self, forKey: .path)
            self = .audio(path: path)
            return
        }
        throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unknown enum case"))
    }

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .text(associatedValue0):
            var associatedValues = container.nestedUnkeyedContainer(forKey: .text)
            try associatedValues.encode(associatedValue0)
        case let .image(path, size):
            var associatedValues = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .image)
            try associatedValues.encode(path, forKey: .path)
            try associatedValues.encode(size, forKey: .size)
        case let .audio(path):
            var associatedValues = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .audio)
            try associatedValues.encode(path, forKey: .path)
        }
    }

}
