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
        return "\\b(?:(in|next|past|this)\\s*)"
            + "(\\s*(months|month))\\b"
    }

    let prefixGroup = 1
    let numberOfMonthsGroup = 2
    let monthGroup = 3

    override func extract(fromParsedItem parsedItem: ParsedItem) -> ParsedResult? {
        guard !parsedItem.match.isEmpty(atRangeIndex: self.monthGroup) else {
            return nil
        }

        var month = parsedItem.refDate.month
        var year = parsedItem.refDate.year

        if !parsedItem.match.isEmpty(atRangeIndex: self.prefixGroup) {
            if parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.prefixGroup).lowercased() == "next" {
                month += 1
            } else if parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.prefixGroup).lowercased() == "past" {
                month -= 1
            }
        }

        if month > 12 {
            month -= 12
            year += 1
        }

        return ParsedResult(
            refDate: parsedItem.refDate,
            matchRange: parsedItem.match.range,
            reservedComponents: [.year: year, .month: month],
            customComponents: [],
            tagUnit: [.ENMonthOffsetParser: true]
        )
    }
}
