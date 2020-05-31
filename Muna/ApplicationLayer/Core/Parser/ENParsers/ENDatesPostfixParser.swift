//
//  ENDatesPostfixParser.swift
//  Muna
//
//  Created by Egor Petrov on 22.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class ENDatesPostfixParser: Parser {
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
            + "(\\s*(\(self.months)))"
            + "(\\s*(0[0-9]|1[0-9]|2[0-9]|3[0-1])([a-z][a-z])(?!(\\:\\d|\\.\\d)))"
    }

    private let prefixGroup = 1
    private let monthGroup = 3
    private let dayGroup = 5

    override func extract(fromParsedItem parsedItem: ParsedItem) -> ParsedResult? {
//        print(parsedItem.match.numberOfRanges)
//        (0 ... 9).forEach {
//            if !parsedItem.match.isEmpty(atRangeIndex: $0) {
//                print("\(parsedItem.match.string(from: parsedItem.text, atRangeIndex: $0)) at index: \($0)")
//            }
//        }
        guard
            !parsedItem.match.isEmpty(atRangeIndex: self.monthGroup),
            var month = self.monthOffset[parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.monthGroup).lowercased()]
        else {
            return nil
        }

        var year = parsedItem.refDate.year

        var prefix = ""
        if !parsedItem.match.isEmpty(atRangeIndex: self.prefixGroup) {
            prefix = parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.prefixGroup).lowercased()
        }

        var day = parsedItem.refDate.day
        if !parsedItem.match.isEmpty(atRangeIndex: self.dayGroup),
            let monthDay = Int(parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.dayGroup)),
            day <= 31,
            day > 0 {
            day = monthDay
        }

        if month > 12 {
            month = 1
            year += 1
        }

        if prefix == "next", month == parsedItem.refDate.month {
            month += 1
        } else if prefix == "next", month >= parsedItem.refDate.month {
            year += 1
        }

        return ParsedResult(
            refDate: parsedItem.refDate,
            reservedComponents: [.year: year, .month: month, .day: day],
            customComponents: [:]
        )
    }
}
