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
        _ = self.merge(allParsedResults)
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

        print(newResults)

        return []
    }
}
