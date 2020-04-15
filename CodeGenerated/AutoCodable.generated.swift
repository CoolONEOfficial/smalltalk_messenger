// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


extension ChatModel {

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        documentId = (try? container.decodeIfPresent(String.self, forKey: .documentId)) ?? ChatModel.defaultDocumentId
        users = try container.decode([String].self, forKey: .users)
        lastMessage = try container.decode(MessageModel.self, forKey: .lastMessage)
        type = try container.decode(ChatType.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(documentId, forKey: .documentId)
        try container.encode(users, forKey: .users)
        try container.encode(lastMessage, forKey: .lastMessage)
        try container.encode(type, forKey: .type)
    }

}

extension ChatType {

    enum CodingKeys: String, CodingKey {
        case personalCorr
        case chat
        case title
        case adminId
        case hexColor
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if container.allKeys.contains(.personalCorr), try container.decodeNil(forKey: .personalCorr) == false {
            self = .personalCorr
            return
        }
        if container.allKeys.contains(.chat), try container.decodeNil(forKey: .chat) == false {
            let associatedValues = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .chat)
            let title = try associatedValues.decode(String.self, forKey: .title)
            let adminId = try associatedValues.decode(String.self, forKey: .adminId)
            let hexColor = try associatedValues.decode(String?.self, forKey: .hexColor)
            self = .chat(title: title, adminId: adminId, hexColor: hexColor)
            return
        }
        throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unknown enum case"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .personalCorr:
            _ = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .personalCorr)
        case let .chat(title, adminId, hexColor):
            var associatedValues = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .chat)
            try associatedValues.encode(title, forKey: .title)
            try associatedValues.encode(adminId, forKey: .adminId)
            try associatedValues.encode(hexColor, forKey: .hexColor)
        }
    }

}


extension MessageModel {

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        documentId = try container.decodeIfPresent(String.self, forKey: .documentId)
        kind = (try? container.decode([MessageKind].self, forKey: .kind)) ?? MessageModel.defaultKind
        userId = try container.decode(String.self, forKey: .userId)
        timestamp = MessageModel.decodeTimestamp(from: container)
        chatId = try container.decodeIfPresent(String.self, forKey: .chatId)
        chatUsers = try container.decodeIfPresent([String].self, forKey: .chatUsers)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(documentId, forKey: .documentId)
        try container.encode(kind, forKey: .kind)
        try container.encode(userId, forKey: .userId)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encodeIfPresent(chatId, forKey: .chatId)
        try container.encodeIfPresent(chatUsers, forKey: .chatUsers)
    }

}

extension MessageModel.MessageKind {

    enum CodingKeys: String, CodingKey {
        case text
        case image
        case audio
        case forward
        case path
        case size
        case userId
    }

    public init(from decoder: Decoder) throws {
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
        if container.allKeys.contains(.forward), try container.decodeNil(forKey: .forward) == false {
            let associatedValues = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .forward)
            let userId = try associatedValues.decode(String.self, forKey: .userId)
            self = .forward(userId: userId)
            return
        }
        throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unknown enum case"))
    }

    public func encode(to encoder: Encoder) throws {
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
        case let .forward(userId):
            var associatedValues = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .forward)
            try associatedValues.encode(userId, forKey: .userId)
        }
    }

}

extension UserModel {

    enum CodingKeys: String, CodingKey {
        case documentId
        case name
        case surname
        case hexColor
        case online
        case typing
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        documentId = try container.decodeIfPresent(String.self, forKey: .documentId)
        name = try container.decode(String.self, forKey: .name)
        surname = try container.decode(String.self, forKey: .surname)
        hexColor = try container.decodeIfPresent(String.self, forKey: .hexColor)
        online = (try? container.decode(Bool.self, forKey: .online)) ?? UserModel.defaultOnline
        typing = try container.decodeIfPresent(String.self, forKey: .typing)
    }

}
