//
//  ENDatesParser.swift
//  Muna
//
//  Created by Egor Petrov on 22.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class ENPrefixDatesParser: Parser {
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
            + "(0[1-9]|1[0-9]|2[0-9]|3[0-1])(?:st|nd|rd|th)?"
            + "((\\.|\\s*(\(self.months)|[1-9]|1[0-2]|month)))"
    }

    private let prefixGroup = 1
    private let dayGroup = 2
    private let monthGroup = 5

    override func extract(fromParsedItems parsedItems: [ParsedItem], toParsedResult results: [DateItem]) -> [DateItem] {
        return parsedItems.map { self.extract(fromParsedItem: $0, toParsedResult: results) }.flatMap { $0 }
    }

    private func extract(fromParsedItem parsedItem: ParsedItem, toParsedResult results: [DateItem]) -> [DateItem] {
//        print(parsedItem.match.numberOfRanges)
//        (0 ... 5).forEach {
//            if !parsedItem.match.isEmpty(atRangeIndex: $0) {
//                print("\(parsedItem.match.string(from: parsedItem.text, atRangeIndex: $0)) at index: \($0)")
//            }
//        }
        guard !parsedItem.match.isEmpty(atRangeIndex: self.dayGroup),
            let day = Int(parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.dayGroup))
        else {
            return []
        }

        var year = parsedItem.refDate.year

        var prefix = ""
        if !parsedItem.match.isEmpty(atRangeIndex: self.prefixGroup) {
            prefix = parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.prefixGroup).lowercased()
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

        var parsedResults = [DateItem]()
        if !results.isEmpty {
            parsedResults = results.map {
                var newItem = $0
                let newDay = PureDay(day: day, month: monthInt, year: year)
                newItem.day = newDay
                return newItem
            }
        } else {
            parsedResults.append(
                DateItem(
                    day: PureDay(day: day, month: monthInt, year: year),
                    timeType: .allDay
                )
            )
        }
        return parsedResults
    }
}
