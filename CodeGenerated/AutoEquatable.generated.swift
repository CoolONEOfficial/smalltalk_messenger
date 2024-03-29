// Generated using Sourcery 1.3.4 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable file_length
fileprivate func compareOptionals<T>(lhs: T?, rhs: T?, compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    switch (lhs, rhs) {
    case let (lValue?, rValue?):
        return compare(lValue, rValue)
    case (nil, nil):
        return true
    default:
        return false
    }
}

fileprivate func compareArrays<T>(lhs: [T], rhs: [T], compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    guard lhs.count == rhs.count else { return false }
    for (idx, lhsItem) in lhs.enumerated() {
        guard compare(lhsItem, rhs[idx]) else { return false }
    }

    return true
}


// MARK: - AutoEquatable for classes, protocols, structs
// MARK: - ChatModel AutoEquatable
extension ChatModel: Equatable {}
public func == (lhs: ChatModel, rhs: ChatModel) -> Bool {
    guard compareOptionals(lhs: lhs.documentId, rhs: rhs.documentId, compare: ==) else { return false }
    guard lhs.users == rhs.users else { return false }
    guard lhs.lastMessage == rhs.lastMessage else { return false }
    guard lhs.type == rhs.type else { return false }
    return true
}
// MARK: - ContactModel AutoEquatable
extension ContactModel: Equatable {}
public func == (lhs: ContactModel, rhs: ContactModel) -> Bool {
    guard compareOptionals(lhs: lhs.documentId, rhs: rhs.documentId, compare: ==) else { return false }
    guard lhs.localName == rhs.localName else { return false }
    guard lhs.userId == rhs.userId else { return false }
    return true
}
// MARK: - MediaModel AutoEquatable
extension MediaModel: Equatable {}
public func == (lhs: MediaModel, rhs: MediaModel) -> Bool {
    guard lhs.path == rhs.path else { return false }
    guard lhs.size == rhs.size else { return false }
    guard lhs.timestamp == rhs.timestamp else { return false }
    return true
}
// MARK: - MessageModel AutoEquatable
extension MessageModel: Equatable {}
public func == (lhs: MessageModel, rhs: MessageModel) -> Bool {
    guard compareOptionals(lhs: lhs.documentId, rhs: rhs.documentId, compare: ==) else { return false }
    guard lhs.kind == rhs.kind else { return false }
    guard lhs.userId == rhs.userId else { return false }
    guard lhs.timestamp == rhs.timestamp else { return false }
    guard compareOptionals(lhs: lhs.chatId, rhs: rhs.chatId, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.chatUsers, rhs: rhs.chatUsers, compare: ==) else { return false }
    return true
}
// MARK: - UserModel AutoEquatable
extension UserModel: Equatable {}
public func == (lhs: UserModel, rhs: UserModel) -> Bool {
    guard compareOptionals(lhs: lhs.documentId, rhs: rhs.documentId, compare: ==) else { return false }
    guard lhs.name == rhs.name else { return false }
    guard lhs.surname == rhs.surname else { return false }
    guard lhs.phoneNumber == rhs.phoneNumber else { return false }
    guard compareOptionals(lhs: lhs.hexColor, rhs: rhs.hexColor, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.avatarPath, rhs: rhs.avatarPath, compare: ==) else { return false }
    guard lhs.online == rhs.online else { return false }
    guard compareOptionals(lhs: lhs.onlineTimestamp, rhs: rhs.onlineTimestamp, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.typing, rhs: rhs.typing, compare: ==) else { return false }
    guard lhs.deleted == rhs.deleted else { return false }
    return true
}

// MARK: - AutoEquatable for Enums
// MARK: - ChatType AutoEquatable
extension ChatType: Equatable {}
public func == (lhs: ChatType, rhs: ChatType) -> Bool {
    switch (lhs, rhs) {
    case (.personalCorr(let lhs), .personalCorr(let rhs)):
        if lhs.between != rhs.between { return false }
        if lhs.betweenNames != rhs.betweenNames { return false }
        return true
    case (.savedMessages, .savedMessages):
        return true
    case (.chat(let lhs), .chat(let rhs)):
        if lhs.title != rhs.title { return false }
        if lhs.adminId != rhs.adminId { return false }
        if lhs.hexColor != rhs.hexColor { return false }
        if lhs.avatarPath != rhs.avatarPath { return false }
        return true
    default: return false
    }
}
// MARK: - MessageModel.MessageKind AutoEquatable
extension MessageModel.MessageKind: Equatable {}
public func == (lhs: MessageModel.MessageKind, rhs: MessageModel.MessageKind) -> Bool {
    switch (lhs, rhs) {
    case (.text(let lhs), .text(let rhs)):
        return lhs == rhs
    case (.image(let lhs), .image(let rhs)):
        if lhs.path != rhs.path { return false }
        if lhs.size != rhs.size { return false }
        return true
    case (.audio(let lhs), .audio(let rhs)):
        return lhs == rhs
    case (.forward(let lhs), .forward(let rhs)):
        return lhs == rhs
    default: return false
    }
}
