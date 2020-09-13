//
//  ENMonthOffsetParser.swift
//  Muna
//
//  Created by Egor Petrov on 01.06.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class ENMonthOffsetParser: Parser {
    override var pattern: String {
        return "\\b(?:(in|next|past|this)\\s*)?"
            + "(?:(\\d{1,}))?"
            + "(\\s*(months|month))\\b"
    }

    let prefixGroup = 1
    let numberOfMonthsGroup = 2
    let monthGroup = 4

    override func extract(fromParsedItem parsedItem: ParsedItem) -> ParsedResult? {
//        print(parsedItem.match.numberOfRanges)
//        (0 ... 4).forEach {
//            if !parsedItem.match.isEmpty(atRangeIndex: $0) {
//                print("\(parsedItem.match.string(from: parsedItem.text, atRangeIndex: $0)) at index: \($0)")
//            }
//        }
        guard !parsedItem.match.isEmpty(atRangeIndex: self.monthGroup) else {
            return nil
        }

        let day = parsedItem.refDate.day
        var month = parsedItem.refDate.month
        var year = parsedItem.refDate.year

        var offset = 0
        if !parsedItem.match.isEmpty(atRangeIndex: self.prefixGroup), parsedItem.match.isEmpty(atRangeIndex: self.numberOfMonthsGroup) {
            if parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.prefixGroup).lowercased() == "next" {
                month += 1
                offset = 1
            } else if parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.prefixGroup).lowercased() == "past" {
                month -= 1
            }
        }

        if !parsedItem.match.isEmpty(atRangeIndex: self.numberOfMonthsGroup),
            let monthsOffset = Int(parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.numberOfMonthsGroup)) {
            month += monthsOffset
            offset = monthsOffset
        }

        while month > 12 {
            month -= 12
            year += 1
        }

        return ParsedResult(
            refDate: parsedItem.refDate,
            matchRange: parsedItem.match.range,
            length: parsedItem.match.range.length,
            reservedComponents: [.year: year, .month: month, .day: day],
            customDayComponents: [],
            customPartOfTheDayComponents: [],
            tagUnit: [.ENMonthOffsetParser: true],
            dateOffset: .month(month: offset)
        )
    }
}
