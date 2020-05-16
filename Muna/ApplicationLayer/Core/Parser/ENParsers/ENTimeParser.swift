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
        return "\\b(?:(?:at|in)\\s*)?"
            + "(([1-9]|1[0-9]|2[0-4]))"
            + "(((?:\\.|\\:||\\.|\\：)([0-5][0-9]))?)"
            + "(?:\\s*(a\\.m\\.|p\\.m\\.|am?|pm?|h?))?\\b"
    }

    let hourGroup = 1
    let minutesGroup = 5
    let partOfTheDayGroup = 6

    private let seconds = 60
    private let hourInSeconds = 60 * 60

    override func extract(fromParsedItem parsedItem: ParsedItem, toParsedResult results: [ParsedResult]) -> [ParsedResult] {
        guard !parsedItem.match.isEmpty(atRangeIndex: self.hourGroup) else {
            return []
        }

        guard var hoursOffset = Int(parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.hourGroup)) else {
            return []
        }

        let nowTime = parsedItem.refDate.hour

        var partOfTheDay = ""
        if !parsedItem.match.isEmpty(atRangeIndex: self.partOfTheDayGroup) {
            partOfTheDay = parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.partOfTheDayGroup)
        }

        if !partOfTheDay.isEmpty, partOfTheDay == "pm", nowTime < 12 {
            hoursOffset = 12 - nowTime + hoursOffset
        }

        var minutesOffset = 0
        if !parsedItem.match.isEmpty(atRangeIndex: self.minutesGroup),
            let minutes = Int(parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.minutesGroup)) {
            minutesOffset = minutes
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
