//
//  SectionArray.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 08.04.2020.
//

import Foundation

struct SectionArray<KeyT: Equatable, ElementT: Equatable>: Equatable, Collection {

    let elements: [ElementT]
    let key: KeyT

    typealias Index = Int

    var startIndex: Int {
        return elements.startIndex
    }

    var endIndex: Int {
        return elements.endIndex
    }
    
    public func at(i: Int) -> ElementT {
        return elements[i]
    }

    subscript(i: Int) -> ElementT {
        return elements[i]
    }

    public func index(after i: Int) -> Int {
        return elements.index(after: i)
    }

    static func == (fst: SectionArray, snd: SectionArray) -> Bool {
        return fst.key == snd.key
    }
}
