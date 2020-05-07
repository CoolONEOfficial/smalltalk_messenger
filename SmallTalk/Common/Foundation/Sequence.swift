//
//  Sequence.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 16.04.2020.
//

import Foundation

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
