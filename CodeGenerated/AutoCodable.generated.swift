// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


extension UserSettingsModel {

    enum CodingKeys: String, CodingKey {
        case userId
        case userPhoneNumber
    }

    internal init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        userId = (try? container.decode(String.self, forKey: .userId)) ?? UserSettingsModel.defaultUserId
        userPhoneNumber = try container.decode(String.self, forKey: .userPhoneNumber)
    }

}
