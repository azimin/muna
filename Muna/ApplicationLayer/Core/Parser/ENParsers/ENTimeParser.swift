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
            + "(([0-9]|[0-5][0-9]|[1-9]|1[0-9]|2[0-4]))"
            + "(((\\.|\\:|\\：)([0-9]|[0-5][0-9]))?)"
            + "(?:\\s*(a\\.m\\.|p\\.m\\.|mins?|minutes?|am?|pm?|h?))?\\b"
    }

    let prefixGroup = 1
    let hourGroup = 3
    let minutesSeparatorGroup = 6
    let minutesGroup = 7
    let partOfTheDayGroup = 8

    private let seconds = 60
    private let hourInSeconds = 60 * 60

    // swiftlint:disable cyclomatic_complexity
    override func extract(fromParsedItem parsedItem: ParsedItem, toParsedResult results: [DateItem]) -> [DateItem] {
        print(parsedItem.match.numberOfRanges)
        (0 ... 8).forEach {
            if !parsedItem.match.isEmpty(atRangeIndex: $0) {
                print("\(parsedItem.match.string(from: parsedItem.text, atRangeIndex: $0)) at index: \($0)")
            }
        }
        guard !parsedItem.match.isEmpty(atRangeIndex: self.hourGroup) || !parsedItem.match.isEmpty(atRangeIndex: self.minutesGroup)
        else {
            return results
        }

        var hoursOffset = 0
        if !parsedItem.match.isEmpty(atRangeIndex: self.hourGroup),
            let hours = Int(parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.hourGroup)) {
            hoursOffset = hours
        }

        var minutesOffset = 0
        if !parsedItem.match.isEmpty(atRangeIndex: self.minutesGroup),
            let minutes = Int(parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.minutesGroup)) {
            minutesOffset = minutes
        }

        var partOfTheDay = ""
        if !parsedItem.match.isEmpty(atRangeIndex: self.partOfTheDayGroup) {
            partOfTheDay = parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.partOfTheDayGroup).lowercased()
        }

        var prefix = ""
        if !parsedItem.match.isEmpty(atRangeIndex: self.prefixGroup) {
            prefix = parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.prefixGroup).lowercased()
        }

        var minutesSeparator = ""
        if !parsedItem.match.isEmpty(atRangeIndex: self.minutesSeparatorGroup) {
            minutesSeparator = parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.minutesSeparatorGroup).lowercased()
        }

        if prefix == "in", partOfTheDay != "mins", partOfTheDay != "minutes" {
            hoursOffset += parsedItem.refDate.hour
        }

        if partOfTheDay == "mins" || partOfTheDay == "minutes" {
            minutesOffset = hoursOffset
            hoursOffset = parsedItem.refDate.hour
        }

        if !partOfTheDay.isEmpty,
            partOfTheDay == "pm" || partOfTheDay == "p.m.",
            prefix != "in" {
            hoursOffset += 12
        }

        if !parsedItem.match.isEmpty(atRangeIndex: self.minutesGroup) {
            if minutesSeparator == " ",
                minutesSeparator == ".",
                prefix == "in" {
                if minutesOffset < 10 {
                    minutesOffset = Int((60.0 / 100.0) * Double(minutesOffset * 10)) + parsedItem.refDate.minute
                } else {
                    minutesOffset += parsedItem.refDate.minute
                }
            }
        }

        if partOfTheDay == "mins" || partOfTheDay == "minutes" {
            minutesOffset += parsedItem.refDate.minute
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
