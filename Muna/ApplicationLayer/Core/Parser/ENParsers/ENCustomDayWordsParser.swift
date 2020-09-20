//
//  ENCustomWordsParser.swift
//  Muna
//
//  Created by Egor Petrov on 01.06.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class ENCustomDayWordsParser: Parser {
    var customUnits: String {
        return CustomDayWords.allCases.map { $0.rawValue }.joined(separator: "|")
    }

    private var prefixes: String {
        return DatePrefix.allCases.map { $0.rawValue }.joined(separator: "|")
    }

    override var pattern: String {
        "\\b(?:(\(self.prefixes)))?\\s*(\(self.customUnits))\\b"
    }

    let prefixItem = 1
    let wordItem = 2

    override func extract(fromParsedItem parsedItem: ParsedItem) -> ParsedResult? {
//        print(parsedItem.match.numberOfRanges)
//        (0 ... 2).forEach {
//            if !parsedItem.match.isEmpty(atRangeIndex: $0) {
//                print("\(parsedItem.match.string(from: parsedItem.text, atRangeIndex: $0)) at index: \($0)")
//            }
//        }
        guard !parsedItem.match.isEmpty(atRangeIndex: self.wordItem) else {
            return nil
        }

        let word = parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.wordItem).lowercased()
        guard let dayComponent = CustomDayWords(rawValue: word) else {
            return nil
        }

        var prefix = ""
        if !parsedItem.match.isEmpty(atRangeIndex: self.prefixItem) {
            prefix = parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.prefixItem).lowercased()
        }

        return ParsedResult(
            refDate: parsedItem.refDate,
            matchRange: parsedItem.match.range,
            length: parsedItem.match.range.length,
            reservedComponents: [:],
            customDayComponents: [dayComponent],
            customPartOfTheDayComponents: [],
            tagUnit: [.ENCustomDayWordsParser: true],
            prefix: DatePrefix(rawValue: prefix)
        )
    }
}
