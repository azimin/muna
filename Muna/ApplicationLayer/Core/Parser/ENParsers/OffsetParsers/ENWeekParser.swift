//
//  ENWeekParser.swift
//  Muna
//
//  Created by Egor Petrov on 17.07.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class ENWeekParser: Parser {
    override var pattern: String {
        return "\\b(?:(in|next|past|this)\\s*)?"
            + "(?:(\\d{1,}))?"
            + "(\\s*(week|weeks))\\b"
    }

    let prefixGroup = 1
    let numberOfWeeksGroup = 2
    let weekGroup = 4

    override func extract(fromParsedItem parsedItem: ParsedItem) -> ParsedResult? {
//        print(parsedItem.match.numberOfRanges)
//        (0 ... 4).forEach {
//            if !parsedItem.match.isEmpty(atRangeIndex: $0) {
//                print("\(parsedItem.match.string(from: parsedItem.text, atRangeIndex: $0)) at index: \($0)")
//            }
//        }
        guard !parsedItem.match.isEmpty(atRangeIndex: self.weekGroup) else {
            return nil
        }

        var day = parsedItem.refDate.day
        var month = parsedItem.refDate.month
        var year = parsedItem.refDate.year

        var offset = 0
        if !parsedItem.match.isEmpty(atRangeIndex: self.prefixGroup), parsedItem.match.isEmpty(atRangeIndex: self.numberOfWeeksGroup) {
            if parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.prefixGroup).lowercased() == "next" {
                day += 7
                offset = 1
            } else if parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.prefixGroup).lowercased() == "past" {
                day -= 7
            }
        }

        if !parsedItem.match.isEmpty(atRangeIndex: self.numberOfWeeksGroup),
            let weeksOffset = Int(parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.numberOfWeeksGroup)) {
            day += 7 * weeksOffset
            offset = weeksOffset
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
            reservedComponents: [.year: year, .month: month, .day: day],
            customDayComponents: [],
            customPartOfTheDayComponents: [],
            tagUnit: [.ENWeekParser: true],
            dateOffset: .week(week: offset)
        )
    }
}
