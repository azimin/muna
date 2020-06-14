//
//  ENTimeOffset.swift
//  Muna
//
//  Created by Egor Petrov on 31.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class ENTimeHoursOffset: Parser {
    override var pattern: String {
        return "\\b(?:in\\s*)"
            + "(\\d{1,})"
            + "(\\.(\\d{1,}))?"
            + "(\\s*(h?|hours?))?\\b"
    }

    let hourGroup = 1
    let minutesGroup = 3

    override func extract(fromParsedItem parsedItem: ParsedItem) -> ParsedResult? {
//        print(parsedItem.match.numberOfRanges)
//        (0 ... 5).forEach {
//            if !parsedItem.match.isEmpty(atRangeIndex: $0) {
//                print("\(parsedItem.match.string(from: parsedItem.text, atRangeIndex: $0)) at index: \($0)")
//            }
//        }
        guard !parsedItem.match.isEmpty(atRangeIndex: self.hourGroup),
            var hourOffset = Int(parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.hourGroup))
        else {
            return nil
        }

        var minutes = parsedItem.refDate.minute
        var hour = parsedItem.refDate.hour
        var day = parsedItem.refDate.day
        var month = parsedItem.refDate.month
        var year = parsedItem.refDate.year

        var minutesOffset = 0
        if !parsedItem.match.isEmpty(atRangeIndex: self.minutesGroup),
            let minutes = Int(parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.minutesGroup)) {
            if minutes < 10 {
                minutesOffset = Int((60.0 / 100.0) * Double(minutes * 10))
            } else {
                minutesOffset = minutes
            }
        }

        minutes += minutesOffset
        hour += hourOffset

        while minutes > 60 {
            hour += 1
            minutes -= 60
        }

        while hour >= 24 {
            hour -= 24
            day += 1
        }

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
            reservedComponents: [
                .year: year,
                .month: month,
                .day: day,
                .hour: hourOffset,
                .minute: minutesOffset,
            ],
            customDayComponents: [],
            customPartOfTheDayComponents: [],
            tagUnit: [.ENTimeHoursOffset: true],
            dateOffset: .hour(hour: hourOffset, minutes: minutesOffset)
        )
    }
}
