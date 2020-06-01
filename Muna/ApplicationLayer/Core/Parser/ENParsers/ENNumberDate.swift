//
//  ENNumberDate.swift
//  Muna
//
//  Created by Egor Petrov on 31.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation
import SwiftDate

class ENNumberDate: Parser {
    override var pattern: String {
        return "\\b(0[1-9]|1[0-9]|2[0-9]|3[0-1])"
            + "(\\.((0[1-9]|1[0-2])(?!(\\:\\d|\\.\\d))))?\\b"
    }

    let dayGroup = 1
    let monthGroup = 3

    override func extract(fromParsedItem parsedItem: ParsedItem) -> ParsedResult? {
//        print(parsedItem.match.numberOfRanges)
//        (0 ... 3).forEach {
//            if !parsedItem.match.isEmpty(atRangeIndex: $0) {
//                print("\(parsedItem.match.string(from: parsedItem.text, atRangeIndex: $0)) at index: \($0)")
//            }
//        }
        guard
            !parsedItem.match.isEmpty(atRangeIndex: self.dayGroup),
            var day = Int(parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.dayGroup))
        else {
            return nil
        }

        var year = parsedItem.refDate.year

        var month = parsedItem.refDate.month
        if !parsedItem.match.isEmpty(atRangeIndex: self.monthGroup),
            var newMonth = Int(parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.monthGroup)) {
            month = newMonth
        }

        return ParsedResult(
            refDate: parsedItem.refDate,
            reservedComponents: [.year: year, .month: month, .day: day],
            customComponents: []
        )
    }
}
