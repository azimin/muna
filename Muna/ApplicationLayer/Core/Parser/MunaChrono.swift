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
        let timeOffset = self.merge(allParsedResults)

        return []
    }

    func merge(_ parsedResult: [ParsedResult]) -> [ParsedResult] {
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
            print($0.matchRange.length)
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

        print(newResults)

        return []
    }
}
