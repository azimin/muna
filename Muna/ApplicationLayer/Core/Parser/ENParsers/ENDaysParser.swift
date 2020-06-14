//
//  ENDaysParser.swift
//  Muna
//
//  Created by Egor Petrov on 27.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class ENDaysParser: Parser {
    override var pattern: String {
        return "\\b(?:in\\s*)(?:(\\d{1,}))\\s*(day|days)?\\b"
    }

    let dayOffsetGroup = 1

    override func extract(fromParsedItem parsedItem: ParsedItem) -> ParsedResult? {
//        print(parsedItem.match.numberOfRanges)
//        (0 ... 2).forEach {
//            if !parsedItem.match.isEmpty(atRangeIndex: $0) {
//                print("\(parsedItem.match.string(from: parsedItem.text, atRangeIndex: $0)) at index: \($0)")
//            }
//        }

        guard !parsedItem.match.isEmpty(atRangeIndex: self.dayOffsetGroup),
            let daysOffset = Int(parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.dayOffsetGroup)) else {
            return nil
        }

        var year = parsedItem.refDate.year
        var month = parsedItem.refDate.month
        var day = parsedItem.refDate.day + daysOffset

        if day > parsedItem.refDate.monthDays {
            day -= parsedItem.refDate.monthDays
            month += 1
        }

        if month > 12 {
            month -= 12
            year += 1
        }

        return ParsedResult(
            refDate: parsedItem.refDate,
            matchRange: parsedItem.match.range,
            reservedComponents: [.year: year, .month: month, .day: day],
            customDayComponents: [],
            customPartOfTheDayComponents: [],
            tagUnit: [.ENDaysParser: true],
            dateOffset: .day(day: daysOffset)
        )
    }
}
