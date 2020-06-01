//
//  ENTimeMintuesOffsetParser.swift
//  Muna
//
//  Created by Egor Petrov on 01.06.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class ENTimeMintuesOffsetParser: Parser {
    override var pattern: String {
        return "\\b(?:in\\s*)"
            + "(\\d{1,})"
            + "(\\s*(mins|minutes?))?\\b"
    }

    private let minutesGroup = 1

    override func extract(fromParsedItem parsedItem: ParsedItem) -> ParsedResult? {
//        print(parsedItem.match.numberOfRanges)
//        (0 ... 2).forEach {
//            if !parsedItem.match.isEmpty(atRangeIndex: $0) {
//                print("\(parsedItem.match.string(from: parsedItem.text, atRangeIndex: $0)) at index: \($0)")
//            }
//        }
        guard
            !parsedItem.match.isEmpty(atRangeIndex: self.minutesGroup),
            var minutesOffset = Int(parsedItem.match.string(from: parsedItem.text, atRangeIndex: minutesGroup))
        else {
            return nil
        }

        var year = parsedItem.refDate.year
        var month = parsedItem.refDate.month
        var day = parsedItem.refDate.day
        var hour = parsedItem.refDate.hour

        minutesOffset += parsedItem.refDate.minute

        if minutesOffset >= 60 {
            hour += 1
            minutesOffset -= 60
        }

        if hour >= 24 {
            day += 1
            hour -= 24
        }

        if day > parsedItem.refDate.monthDays {
            month += 1
            day -= parsedItem.refDate.monthDays
        }

        if month > 12 {
            month -= 1
            year += 1
        }

        return ParsedResult(
            refDate: parsedItem.refDate,
            matchRange: parsedItem.match.range,
            reservedComponents:
            [
                .year: year,
                .month: month,
                .day: day,
                .hour: hour,
                .minute: minutesOffset,
            ],
            customComponents: [],
            tagUnit: [.ENTimeMintuesOffsetParser: true]
        )
    }
}
