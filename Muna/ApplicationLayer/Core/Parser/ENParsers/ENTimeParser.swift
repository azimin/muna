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
            + "(((\\.|\\:|\\：|\\s)([0-9]|[0-5][0-9]))?)"
            + "(?:\\s*(a\\.m\\.|p\\.m\\.|am?|pm?|h?))?\\b"
    }

    let prefixGroup = 1
    let hourGroup = 3
    let minutesSeparatorGroup = 6
    let minutesGroup = 7
    let partOfTheDayGroup = 8

    private let seconds = 60
    private let hourInSeconds = 60 * 60

    override func extract(fromParsedItem parsedItem: ParsedItem, toParsedResult results: [DateItem]) -> [DateItem] {
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

        if prefix == "in" {
            hoursOffset = parsedItem.refDate.hour + hoursOffset
        }

        if !partOfTheDay.isEmpty, partOfTheDay == "pm", prefix != "in" {
            hoursOffset += 12
        }

        var minutesOffset = parsedItem.refDate.minute

        if !parsedItem.match.isEmpty(atRangeIndex: self.minutesGroup),
            let minutes = Int(parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.minutesGroup)) {
            if !parsedItem.match.isEmpty(atRangeIndex: self.minutesSeparatorGroup),
                parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.minutesSeparatorGroup) == ".",
                prefix == "in" {
                if minutes < 10 || minutesOffset % 10 == 0 {
                    minutesOffset += Int((60.0 / 100.0) * Double(minutes * 10))
                } else {
                    minutesOffset += Int((60.0 / 100.0) * Double(minutes))
                }
            } else {
                minutesOffset = minutes
            }
        }

        let parsedTime = TimeOfDay(hours: hoursOffset, minutes: minutesOffset, seconds: 0)

        var parsedResults = [DateItem]()

        if !results.isEmpty {
            parsedResults = results.map {
                var newTime = $0
                newTime.day = $0.day
                newTime.timeType = .specificTime(timeOfDay: parsedTime)

                return newTime
            }
        } else {
            let dayFromRefDate = PureDay(day: parsedItem.refDate.day, month: parsedItem.refDate.month, year: parsedItem.refDate.year)
            parsedResults.append(
                DateItem(
                    day: dayFromRefDate,
                    timeType: .specificTime(timeOfDay: parsedTime)
                )
            )
        }
        return parsedResults
    }
}
