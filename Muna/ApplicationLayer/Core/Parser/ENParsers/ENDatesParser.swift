//
//  ENDatesParser.swift
//  Muna
//
//  Created by Egor Petrov on 22.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class ENDatesParser: Parser {
    private let monthOffset = [
        "december": 12,
        "dec": 12,
        "january": 1,
        "jan": 1,
        "february": 2,
        "feb": 2,
        "march": 3,
        "mar": 3,
        "april": 4,
        "apr": 4,
        "may": 5,
        "june": 6,
        "july": 7,
        "august": 8,
        "aug": 8,
        "september": 9,
        "sep": 9,
        "october": 10,
        "oct": 10,
        "november": 11,
        "nov": 11,
    ]

    private var months: String {
        return self.monthOffset.keys.map { $0 }.joined(separator: "|")
    }

    override var pattern: String {
        return "\\b(?:(next|this))?"
            + "((0[0-9]|1[0-9]|2[0-9]|3[0-1])?)"
            + "((\\.|\\s*(\(self.months)|[0-9]|1[0-2]|month))?)"
            + "(\\s*(0[0-9]|1[0-9]|2[0-9]|3[0-1])([a-z][a-z]))?\\b"
    }

    override func extract(fromParsedItem parsedItem: ParsedItem, toParsedResult results: [DateItem]) -> [DateItem] {
//        let weekdayName = parsedItem.match.string(from: parsedItem.text, atRangeIndex: 2).lowercased()
//        guard let monthOffset = self.monthOffset[weekdayName] else {
//            return results
//        }

        print(parsedItem.match.numberOfRanges)
        (0 ... 8).forEach {
            if !parsedItem.match.isEmpty(atRangeIndex: $0) {
                print("\(parsedItem.match.string(from: parsedItem.text, atRangeIndex: $0)) at index: \($0)")
            }
        }
        return results
    }
}
