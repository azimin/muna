//
//  MunaChrono.swift
//  Muna
//
//  Created by Egor Petrov on 12.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class MunaChrono {
    private let parsers = [
        ENTimeParser(),
        ENWeekdaysParser(),
        ENDatesPrefixParser(),
        ENDatesPostfixParser(),
        ENDaysParser(),
        ENNumberDate(),
        ENTimeHoursOffset(),
        ENCustomDayWordsParser(),
        ENCustomPartOfTheDayWordsParser(),
        ENTimeMintuesOffsetParser(),
        ENMonthOffsetParser(),
        ENWeekParser(),
    ]

    func parseFromString(_ string: String, date: Date) -> [ParsedResult] {
        var allParsedResults = [ParsedResult]()

        self.parsers.forEach {
            allParsedResults += $0.parse(fromText: string, refDate: date)
        }

//        allParsedResults.forEach {
//            print($0)
//        }
        let timeOffset = self.mergeTimeOffsets(allParsedResults)

        guard timeOffset.isEmpty else {
            return timeOffset
        }

        let dates = self.mergeDates(allParsedResults)

        guard dates.isEmpty else {
            return dates
        }

        let weekdays = self.mergeWeekdays(allParsedResults)

        guard weekdays.isEmpty else {
            return weekdays
        }

        let customWeekdays = self.mergeCustomDays(allParsedResults)

        guard customWeekdays.isEmpty else {
            return customWeekdays
        }

        let numberedDates = self.mergeNumberDates(allParsedResults)

        guard numberedDates.isEmpty else {
            return numberedDates
        }

        let time = self.mergeTime(allParsedResults)

        return time
    }

    func mergeTimeOffsets(_ parsedResult: [ParsedResult]) -> [ParsedResult] {
        let timeOffset = parsedResult.filter {
            $0.tagUnit.keys.contains(.ENTimeHoursOffset)
                || $0.tagUnit.keys.contains(.ENTimeMintuesOffsetParser)
                || $0.tagUnit.keys.contains(.ENDaysParser)
                || $0.tagUnit.keys.contains(.ENMonthOffsetParser)
                || $0.tagUnit.keys.contains(.ENWeekParser)
        }

        var theBiggestRange = NSRange()
        var newResults = [ParsedResult]()

        timeOffset.forEach {
            if $0.matchRange.length == theBiggestRange.length {
                newResults.append($0)
            }

            if $0.matchRange.length > theBiggestRange.length {
                newResults = [$0]
                theBiggestRange = $0.matchRange
            }
        }

        newResults = self.appendTime(to: newResults, fromAllResults: parsedResult)

        return newResults
    }

    func mergeDates(_ parsedResult: [ParsedResult]) -> [ParsedResult] {
        let parsedDates = parsedResult.filter {
            $0.tagUnit.keys.contains(.ENDatesPrefixParser) || $0.tagUnit.keys.contains(.ENDatesPostfixParser)
        }

        var theBiggestRange = NSRange()
        var newDates = [ParsedResult]()
        parsedDates.forEach {
            if $0.matchRange.length == theBiggestRange.length {
                newDates.append($0)
            }

            if $0.matchRange.length > theBiggestRange.length {
                newDates = [$0]
                theBiggestRange = $0.matchRange
            }
        }

        guard !newDates.isEmpty else {
            return newDates
        }

        newDates = self.appendTime(to: newDates, fromAllResults: parsedResult)

        return newDates
    }

    func mergeNumberDates(_ parsedResult: [ParsedResult]) -> [ParsedResult] {
        let parsedDates = parsedResult.filter {
            $0.tagUnit.keys.contains(.ENNumberDate)
        }

        var theBiggestRange = NSRange()
        var newDates = [ParsedResult]()
        parsedDates.forEach {
            if $0.matchRange.length == theBiggestRange.length {
                newDates.append($0)
            }

            if $0.matchRange.length > theBiggestRange.length {
                newDates = [$0]
                theBiggestRange = $0.matchRange
            }
        }

        theBiggestRange = NSRange()
        let parsedTime = parsedResult.filter {
            $0.tagUnit.keys.contains(.ENTimeParser)
        }
        var newTime = [ParsedResult]()
        parsedTime.forEach {
            if $0.matchRange.length == theBiggestRange.length {
                newTime.append($0)
            }

            if $0.matchRange.length > theBiggestRange.length {
                newTime = [$0]
                theBiggestRange = $0.matchRange
            }
        }

        var finalResult = [ParsedResult]()
        newDates.forEach {
            var newDate = $0
            newTime.forEach { time in
                if newDate.reservedComponents.keys.contains(.hour) {
                    return
                }

                if newDate.matchRange.intersection(time.matchRange) != nil {
                    if newDate.matchRange.length == time.matchRange.length,
                        newDate.matchRange.lowerBound == time.matchRange.lowerBound,
                        newDate.matchRange.upperBound == time.matchRange.upperBound {
                        finalResult.append(time)
                    }

                    if newDate.matchRange.length < time.matchRange.length {
                        newDate = time
                    }
                    return
                }

                guard let hour = time.reservedComponents[.hour] else {
                    return
                }

                newDate.reservedComponents[.hour] = hour
                newDate.reservedComponents[.minute] = 0

                guard let minutes = time.reservedComponents[.minute] else {
                    return
                }

                newDate.reservedComponents[.minute] = minutes
            }
            finalResult.append(newDate)
        }

        return finalResult
    }

    func mergeWeekdays(_ parsedResult: [ParsedResult]) -> [ParsedResult] {
        let parsedDates = parsedResult.filter {
            $0.tagUnit.keys.contains(.ENWeekdaysParser)
        }

        var theBiggestRange = NSRange()
        var newDates = [ParsedResult]()
        parsedDates.forEach {
            if $0.matchRange.length == theBiggestRange.length {
                newDates.append($0)
            }

            if $0.matchRange.length > theBiggestRange.length {
                newDates = [$0]
                theBiggestRange = $0.matchRange
            }
        }

        newDates = self.appendTime(to: newDates, fromAllResults: parsedResult)

        return newDates
    }

    func mergeCustomDays(_ parsedResult: [ParsedResult]) -> [ParsedResult] {
        let parsedDates = parsedResult.filter {
            $0.tagUnit.keys.contains(.ENCustomDayWordsParser)
        }

        var theBiggestRange = NSRange()
        var newDates = [ParsedResult]()
        parsedDates.forEach {
            if $0.matchRange.length == theBiggestRange.length {
                newDates.append($0)
            }

            if $0.matchRange.length > theBiggestRange.length {
                newDates = [$0]
                theBiggestRange = $0.matchRange
            }
        }

        newDates = self.appendTime(to: newDates, fromAllResults: parsedResult)
        return newDates
    }

    private func mergeTime(_ parsedResult: [ParsedResult]) -> [ParsedResult] {
        var theBiggestRange = NSRange()
        let parsedTime = parsedResult.filter {
            $0.tagUnit.keys.contains(.ENTimeParser)
        }
        var newTime = [ParsedResult]()
        parsedTime.forEach {
            if $0.matchRange.length == theBiggestRange.length {
                newTime.append($0)
            }

            if $0.matchRange.length > theBiggestRange.length {
                newTime = [$0]
                theBiggestRange = $0.matchRange
            }
        }

        let customTimeWords = parsedResult.filter {
            $0.tagUnit.keys.contains(.ENCustomPartOfTheDayWordsParser)
        }

        newTime.append(contentsOf: customTimeWords)

        return newTime
    }

    private func appendTime(to parsedResult: [ParsedResult], fromAllResults allResults: [ParsedResult]) -> [ParsedResult] {
        var theBiggestRange = NSRange()
        let parsedTime = allResults.filter {
            $0.tagUnit.keys.contains(.ENTimeParser)
        }
        var newTime = [ParsedResult]()
        parsedTime.forEach {
            if $0.matchRange.length == theBiggestRange.length {
                newTime.append($0)
            }

            if $0.matchRange.length > theBiggestRange.length {
                newTime = [$0]
                theBiggestRange = $0.matchRange
            }
        }

        let customTimeWords = allResults.filter {
            $0.tagUnit.keys.contains(.ENCustomPartOfTheDayWordsParser)
        }

        newTime.append(contentsOf: customTimeWords)

        newTime = newTime.filter { time in
            var isIntersects = false
            parsedResult.forEach { result in
                if isIntersects {
                    return
                }

                isIntersects = result.matchRange.intersection(time.matchRange) != nil
            }
            return !isIntersects
        }

        if newTime.isEmpty {
            return parsedResult
        }

        var finalResults = [ParsedResult]()
        newTime.forEach { time in
            parsedResult.forEach {
                var newDate = $0
                if newDate.reservedComponents.keys.contains(.hour) {
                    finalResults.append(newDate)
                    return
                }

                if newDate.matchRange.intersection(time.matchRange) != nil {
                    finalResults.append(newDate)
                    return
                }

                guard let hour = time.reservedComponents[.hour] else {
                    if !time.customPartOfTheDayComponents.isEmpty {
                        newDate.customPartOfTheDayComponents.append(contentsOf: time.customPartOfTheDayComponents)
                    }
                    finalResults.append(newDate)
                    return
                }

                newDate.reservedComponents[.hour] = hour
                newDate.reservedComponents[.minute] = 0

                guard let minutes = time.reservedComponents[.minute] else {
                    finalResults.append(newDate)
                    return
                }

                newDate.reservedComponents[.minute] = minutes

                finalResults.append(newDate)
            }
        }
        return finalResults
    }
}
