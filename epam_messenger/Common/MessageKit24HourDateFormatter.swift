//
//  MessageKit24HourDateFormatter.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 11.03.2020.
//

import Foundation

open class MessageKit24HourDateFormatter {

    // MARK: - Properties

    public static let shared = MessageKit24HourDateFormatter()

    private let dateFormatter = DateFormatter()

    // MARK: - Initializer

    private init() {}

    // MARK: - Methods

    public func string(from date: Date) -> String {
        configureDateFormatter(for: date)
        return dateFormatter.string(from: date)
    }

    public func attributedString(from date: Date, with attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let dateString = string(from: date)
        return NSAttributedString(string: dateString, attributes: attributes)
    }

    open func configureDateFormatter(for date: Date) {
        switch true {
        case Calendar.current.isDateInToday(date) || Calendar.current.isDateInYesterday(date):
            dateFormatter.doesRelativeDateFormatting = true
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
        case Calendar.current.isDate(date, equalTo: Date(), toGranularity: .weekOfYear):
            dateFormatter.dateFormat = "EEEE"
        case Calendar.current.isDate(date, equalTo: Date(), toGranularity: .year):
            dateFormatter.dateFormat = "E, d MMM"
        default:
            dateFormatter.dateFormat = "MMM d, yyyy"
        }
    }
    
}
