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
        return "\\b(?:(at|in)\\s*)?"
            + "(([1-9]|1[0-9]|2[0-4]))"
            + "(((\\.|\\:|\\：)([0-5][0-9]))?)"
            + "(?:\\s*(a\\.m\\.|p\\.m\\.|am?|pm?|h?))?\\b"
    }

    let prefixGroup = 1
    let hourGroup = 3
    let minutesSeparatorGroup = 6
    let minutesGroup = 7
    let partOfTheDayGroup = 8

    private let seconds = 60
    private let hourInSeconds = 60 * 60

    override func extract(fromParsedItem parsedItem: ParsedItem, toParsedResult results: [ParsedResult]) -> [ParsedResult] {
        guard !parsedItem.match.isEmpty(atRangeIndex: self.hourGroup) else {
            return results
        }

        guard var hoursOffset = Int(parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.hourGroup)) else {
            return results
        }

        var partOfTheDay = ""
        if !parsedItem.match.isEmpty(atRangeIndex: self.partOfTheDayGroup) {
            partOfTheDay = parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.partOfTheDayGroup).lowercased()
        }

        var prefix = ""
        if !parsedItem.match.isEmpty(atRangeIndex: self.prefixGroup) {
            prefix = parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.prefixGroup).lowercased()
        }

        if !partOfTheDay.isEmpty, partOfTheDay == "pm", prefix != "in" {
            hoursOffset += 12
        }

        var minutesOffset = 0
        (0 ... 8).forEach {
            if !parsedItem.match.isEmpty(atRangeIndex: $0) {
                print("\(parsedItem.match.string(from: parsedItem.text, atRangeIndex: $0)) at index: \($0)")
            }
        }
        if !parsedItem.match.isEmpty(atRangeIndex: self.minutesGroup),
            let minutes = Int(parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.minutesGroup)) {
            if !parsedItem.match.isEmpty(atRangeIndex: self.minutesSeparatorGroup),
                parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.minutesSeparatorGroup) == ".",
                prefix == "in" {
                if minutes < 10 || minutesOffset % 10 == 0 {
                    minutesOffset = (60 / 100) * (minutes * 10)
                } else {
                    minutesOffset = (60 / 100) * minutes
                }
            } else {
                minutesOffset = minutes
            }
        }

        let time = hoursOffset * self.hourInSeconds + minutesOffset * self.seconds
        let parsedTime = ParsedTime(
            timeUnit: .specificTime,
            hours: time
        )
        var parsedResults = [ParsedResult]()
        if !results.isEmpty {
            parsedResults = results.map {
                var newTime = $0
                newTime.range.append(parsedItem.match.range)
                newTime.time = parsedTime
                return newTime
            }
        } else {
            parsedResults.append(
                ParsedResult(
                    range: [parsedItem.match.range],
                    date: parsedItem.refDate,
                    time: parsedTime
                )
            )
        }
        return parsedResults
    }
}
