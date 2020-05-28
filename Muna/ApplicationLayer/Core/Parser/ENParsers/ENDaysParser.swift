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
        return "\\b(?:in\\s*)(?:(\\d{1,}))\\s*(day|days)\\b"
    }

    let dayOffsetGroup = 1

    override func extract(fromParsedItems parsedItems: [ParsedItem], toParsedResult results: [DateItem]) -> [DateItem] {
        return parsedItems.map { self.extract(fromParsedItem: $0, toParsedResult: results) }.flatMap { $0 }
    }

    private func extract(fromParsedItem parsedItem: ParsedItem, toParsedResult results: [DateItem]) -> [DateItem] {
        print(parsedItem.match.numberOfRanges)
        (0 ... 2).forEach {
            if !parsedItem.match.isEmpty(atRangeIndex: $0) {
                print("\(parsedItem.match.string(from: parsedItem.text, atRangeIndex: $0)) at index: \($0)")
            }
        }

        guard !parsedItem.match.isEmpty(atRangeIndex: self.dayOffsetGroup),
            let daysOffset = Int(parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.dayOffsetGroup)) else {
            return results
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

        var parsedResults = [DateItem]()
        if !results.isEmpty {
            parsedResults = results.map {
                var newItem = $0
                let newDay = PureDay(day: day, month: month, year: year)
                newItem.day = newDay
                return newItem
            }
        } else {
            parsedResults.append(
                DateItem(
                    day: PureDay(day: day, month: month, year: year),
                    timeType: .allDay
                )
            )
        }
        return parsedResults
    }
}
