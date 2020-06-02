//
//  ENTimeParser.swift
//  Muna
//
//  Created by Egor Petrov on 11.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class ENTimeParser: Parser {
    override var pattern: String {
        return "\\b(?:(at)\\s*)?"
            + "(([0-9]|[0-5][0-9]|[1-9]|1[0-9]|2[0-4]))"
            + "(((\\.|\\:|\\：|\\s)([0-9]|[0-5][0-9]))?)"
            + "(?:\\s*(a\\.m\\.|p\\.m\\.|am?|pm?))?\\b"
    }

    let prefixGroup = 1
    let hourGroup = 3
    let minutesSeparatorGroup = 6
    let minutesGroup = 7
    let partOfTheDayGroup = 8

    private let seconds = 60
    private let hourInSeconds = 60 * 60

    // swiftlint:disable cyclomatic_complexity
    override func extract(fromParsedItem parsedItem: ParsedItem) -> ParsedResult? {
//        print(parsedItem.match.numberOfRanges)
//        (0 ... 8).forEach {
//            if !parsedItem.match.isEmpty(atRangeIndex: $0) {
//                print("\(parsedItem.match.string(from: parsedItem.text, atRangeIndex: $0)) at index: \($0)")
//            }
//        }
        guard !parsedItem.match.isEmpty(atRangeIndex: self.hourGroup),
            var hoursOffset = Int(parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.hourGroup)),
            hoursOffset < 24
        else {
            return nil
        }

        var minutesOffset = 0
        if !parsedItem.match.isEmpty(atRangeIndex: self.minutesGroup),
            let minutes = Int(parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.minutesGroup)),
            minutes < 60 {
            minutesOffset = minutes
        }

        var partOfTheDay = ""
        if !parsedItem.match.isEmpty(atRangeIndex: self.partOfTheDayGroup) {
            partOfTheDay = parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.partOfTheDayGroup).lowercased()
        }

        if !partOfTheDay.isEmpty,
            partOfTheDay == "pm" || partOfTheDay == "p.m." {
            hoursOffset += 12
        }

        return ParsedResult(
            refDate: parsedItem.refDate,
            matchRange: parsedItem.match.range,
            reservedComponents: [.hour: hoursOffset, .minute: minutesOffset],
            customDayComponents: [],
            customPartOfTheDayComponents: [],
            tagUnit: [.ENTimeParser: true]
        )
    }
}
