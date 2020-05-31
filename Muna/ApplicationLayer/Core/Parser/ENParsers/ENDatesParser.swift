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

    private let prefixGroup = 1
    private let prefixDayGroup = 2
    private let monthGroup = 6
    private let postfixDayGroup = 8

    override func extract(fromParsedItem parsedItem: ParsedItem) -> ParsedResult? {
//        print(parsedItem.match.numberOfRanges)
//        (0 ... 9).forEach {
//            if !parsedItem.match.isEmpty(atRangeIndex: $0) {
//                print("\(parsedItem.match.string(from: parsedItem.text, atRangeIndex: $0)) at index: \($0)")
//            }
//        }
        guard !parsedItem.match.isEmpty(atRangeIndex: self.prefixDayGroup)
            || !parsedItem.match.isEmpty(atRangeIndex: self.monthGroup)
            || !parsedItem.match.isEmpty(atRangeIndex: self.postfixDayGroup)
        else {
            return nil
        }

        var year = parsedItem.refDate.year

        var prefix = ""
        if !parsedItem.match.isEmpty(atRangeIndex: self.prefixGroup) {
            prefix = parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.prefixGroup).lowercased()
        }

        var day = parsedItem.refDate.day
        if !parsedItem.match.isEmpty(atRangeIndex: self.prefixDayGroup),
            let monthDay = Int(parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.prefixDayGroup)) {
            day = monthDay
        } else if !parsedItem.match.isEmpty(atRangeIndex: self.postfixDayGroup),
            let monthDay = Int(parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.postfixDayGroup)) {
            day = monthDay
        }

        var monthInt = parsedItem.refDate.month
        var monthString = ""
        if !parsedItem.match.isEmpty(atRangeIndex: self.monthGroup) {
            if let monthOfYear = self.monthOffset[parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.monthGroup).lowercased()] {
                monthInt = monthOfYear
            } else {
                monthString = parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.monthGroup).lowercased()
            }
        }

        if prefix == "next", monthString == "month" {
            monthInt += 1
        } else if prefix == "next" {
            year += 1
        }

        if monthInt > 12 {
            monthInt = 1
            year += 1
        }

        return ParsedResult(
            refDate: parsedItem.refDate,
            reservedComponents: [.year: year, .month: monthInt, .day: day],
            customComponents: [:]
        )
    }
}
