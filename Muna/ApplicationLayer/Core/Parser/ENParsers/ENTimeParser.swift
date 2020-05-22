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

        var minutesOffset = 0
        if !parsedItem.match.isEmpty(atRangeIndex: self.minutesGroup),
            let minutes = Int(parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.minutesGroup)) {
            if !parsedItem.match.isEmpty(atRangeIndex: self.minutesSeparatorGroup),
                parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.minutesSeparatorGroup) == ".",
                prefix == "in" {
                if minutes < 10 {
                    minutesOffset += Int((60.0 / 100.0) * Double(minutes * 10)) + parsedItem.refDate.minute
                } else {
                    minutesOffset += minutes + parsedItem.refDate.minute
                }
            } else {
                minutesOffset = minutes
            }
        }

        if prefix == "in", minutesOffset == 0 {
            minutesOffset = parsedItem.refDate.minute
        }

        var parsedResults = [DateItem]()

        if !results.isEmpty {
            parsedResults = results.map {
                var newItem = $0
                if minutesOffset >= 60 {
                    hoursOffset += 1
                    minutesOffset -= 60
                }

                if hoursOffset >= 24 {
                    hoursOffset -= 24
                    newItem.day.day += 1
                }

                let newTime = TimeOfDay(hours: hoursOffset, minutes: minutesOffset, seconds: 0)
                newItem.timeType = .specificTime(timeOfDay: newTime)
                return newItem
            }
        } else {
            var dayFromRefDate = PureDay(day: parsedItem.refDate.day, month: parsedItem.refDate.month, year: parsedItem.refDate.year)
            if minutesOffset >= 60 {
                hoursOffset += 1
                minutesOffset -= 60
            }

            if hoursOffset < parsedItem.refDate.hour, prefix != "in" {
                dayFromRefDate.day += 1
            }

            if hoursOffset >= 24 {
                hoursOffset -= 24
                dayFromRefDate.day += 1
            }

            let newTime = TimeOfDay(hours: hoursOffset, minutes: minutesOffset, seconds: 0)

            parsedResults.append(
                DateItem(
                    day: dayFromRefDate,
                    timeType: .specificTime(timeOfDay: newTime)
                )
            )
        }
        return parsedResults
    }
}
