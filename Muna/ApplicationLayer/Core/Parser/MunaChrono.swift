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
        ENCustomWordsParser(),
        ENTimeMintuesOffsetParser(),
        ENMonthOffsetParser(),
    ]

    func parseFromString(_ string: String, date: Date) -> [DateItem] {
        var allParsedResults = [ParsedResult]()

        self.parsers.forEach {
            allParsedResults += $0.parse(fromText: string, refDate: date)
        }

//        allParsedResults.forEach {
//            print($0)
//        }
        let timeOffset = self.mergeTimeOffsets(allParsedResults)

        guard timeOffset.isEmpty else {
            return []
        }

        let dates = self.mergeDates(allParsedResults)

        guard dates.isEmpty else {
            return []
        }

        let numberedDates = self.mergeNumberDates(allParsedResults)

        return []
    }

    func mergeTimeOffsets(_ parsedResult: [ParsedResult]) -> [ParsedResult] {
        let timeOffset = parsedResult.filter {
            $0.tagUnit.keys.contains(.ENTimeHoursOffset) || $0.tagUnit.keys.contains(.ENTimeMintuesOffsetParser) || $0.tagUnit.keys.contains(.ENDaysParser)
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

        let times = parsedResult.filter {
            $0.tagUnit.keys.contains(.ENTimeParser)
        }

        theBiggestRange = NSRange()
        var timesResult = [ParsedResult]()
        times.forEach {
            if $0.matchRange.length == theBiggestRange.length {
                timesResult.append($0)
            }

            if $0.matchRange.length > theBiggestRange.length {
                timesResult = [$0]
                theBiggestRange = $0.matchRange
            }
        }

        newResults = newResults.map {
            var newResult = $0
            timesResult.forEach { time in
                if newResult.reservedComponents.keys.contains(.hour) {
                    return
                }

                if newResult.matchRange.intersection(time.matchRange) != nil {
                    return
                }

                guard let hour = time.reservedComponents[.hour] else {
                    return
                }

                newResult.reservedComponents[.hour] = hour
                newResult.reservedComponents[.minute] = 0

                guard let minutes = time.reservedComponents[.minute] else {
                    return
                }

                newResult.reservedComponents[.minute] = minutes
            }
            return newResult
        }

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

        newDates = newDates.map {
            var newDate = $0
            newTime.forEach { time in
                if newDate.reservedComponents.keys.contains(.hour) {
                    return
                }

                if newDate.matchRange.intersection(time.matchRange) != nil {
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
            return newDate
        }

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

        print(finalResult)
        return newDates
    }
}
