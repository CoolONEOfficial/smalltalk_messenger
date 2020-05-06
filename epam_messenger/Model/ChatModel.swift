//
//  ChatModel.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 08.03.2020.
//

import Foundation
import Firebase
import CodableFirebase

public struct ChatModel: AutoCodable, AutoEquatable {
    
    var documentId: String!
    var users: [String]
    let lastMessage: MessageModel
    var type: ChatType
    
    enum CodingKeys: String, CodingKey {
        case documentId
        case users
        case lastMessage
        case type
        case enumCaseKey
    }
    
    static func fromUserId(
        _ userId: String,
        firestoreService: FirestoreServiceProtocol = FirestoreService(),
        completion: @escaping (ChatModel) -> Void
    ) {
        firestoreService.getUserData(userId) { user in
            completion(.fromUserId(userId, friendName: user?.fullName))
        }
    }
    
    static func fromUserId(
        _ userId: String,
        friendName: String? = nil,
        lastMessageKind: [MessageModel.MessageKind] = []
    ) -> ChatModel {
        .init(
            documentId: nil,
            users: Auth.auth().currentUser!.uid != userId
                ? [
                    Auth.auth().currentUser!.uid,
                    userId
                    ]
                : [ userId ],
            lastMessage: .empty(kind: lastMessageKind),
            type: Auth.auth().currentUser!.uid != userId
                ? .personalCorr(
                    between: [
                        Auth.auth().currentUser!.uid,
                        userId
                    ],
                    betweenNames: [
                        nil,
                        friendName
                    ]
                ) : .savedMessages
        )
    }
    
    static func empty(documentId: String? = nil) -> ChatModel {
        .init(
            documentId: documentId,
            users: [ Auth.auth().currentUser!.uid ],
            lastMessage: .emptyChat(),
            type: .chat(
                title: "",
                adminId: Auth.auth().currentUser!.uid,
                hexColor: nil,
                avatarPath: nil
            )
        )
    }
    
    static let defaultDocumentId: String! = nil
    
    static func fromSnapshot(_ snapshot: DocumentSnapshot) -> ChatModel? {
        var data = snapshot.data() ?? [:]
        data["documentId"] = snapshot.documentID
        
        do {
            return try FirestoreDecoder()
                .decode(
                    ChatModel.self,
                    from: data
            )
        } catch let err {
            debugPrint("error while parse chat model: \(err)")
            return nil
        }
    }
}

extension ChatModel: ChatProtocol {
    
    private var friendIndex: Int? {
        if case .personalCorr(let between, _) = type {
            return between.firstIndex(where: { Auth.auth().currentUser!.uid != $0 })
        }
        return nil
    }
    
    var friendId: String? {
        if case .personalCorr(let between, _) = type,
            let friendIndex = friendIndex {
            return between[friendIndex]
        }
        return nil
    }
    
    var friendName: String? {
        if case .personalCorr(_, let betweenNames) = type,
            let friendIndex = friendIndex {
            return betweenNames.count > friendIndex ? betweenNames[friendIndex] : nil
        }
        return nil
    }
    
    var avatarRef: StorageReference? {
        if case .chat(_, _, _, let avatarPath) = type,
            let path = avatarPath {
            return Storage.storage().reference(withPath: path)
        }
        
        return nil
    }
    
    private func subtitle(_ user: inout UserModel) -> String {
        self.documentId != nil
        && user.typing == self.documentId
            ? "\(user.name) typing..."
            : user.onlineText
    }
    
    func listenInfo(completion: @escaping (
        _ title: String, _ subtitle: String,
        _ placeholderText: String?, _ placeholderColor: UIColor?
        ) -> Void) {
        let firestoreService = FirestoreService()
        
        switch type {
        case .savedMessages:
            completion("Saved messages", "", "", nil)
        case .personalCorr:
            if let friendId = friendId {
                firestoreService.listenUserData(friendId) { user in
                    var maybeDeletedUser = user ?? .deleted(friendId)
                    let title = self.friendName ?? maybeDeletedUser.fullName
                    
                    completion(
                        title,
                        self.subtitle(&maybeDeletedUser),
                        user?.placeholderName,
                        user?.color
                    )
                    if maybeDeletedUser.onlineTimestamp != nil {
                        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                            completion(
                                title,
                                self.subtitle(&maybeDeletedUser),
                                user?.placeholderName,
                                user?.color
                            )
                        }
                    }
                }
            }
        case .chat(let title, _, let color, _):
            firestoreService.listenUserListData(users) { userList in
                if let userList = userList {
                    let typingUsers = userList.filter({
                        $0.typing == self.documentId
                            && $0.documentId != Auth.auth().currentUser!.uid
                    })
                    let subtitleStr: String
                    if typingUsers.isEmpty {
                        let onlineUsers = userList.filter({ $0.online })
                        subtitleStr = "\(self.users.count) users"
                            + (onlineUsers.count > 1
                                ? ", \(onlineUsers.count) online"
                                : "")
                    } else {
                        subtitleStr = typingUsers
                            .map({ $0.name })
                            .joined(separator: ", ") + " typing..."
                    }
                    
                    completion(
                        title,
                        subtitleStr,
                        String(title.first ?? " "),
                        UIColor(hexString: color)
                    )
                }
            }
        }
    }
    
}
