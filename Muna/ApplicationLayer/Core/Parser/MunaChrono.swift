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
    ]

    func parseFromString(_ string: String, date: Date) -> [DateItem] {
        var allParsedResults = [ParsedResult]()

        self.parsers.forEach {
            allParsedResults += $0.parse(fromText: string, refDate: date)
        }

        allParsedResults.forEach {
            print($0)
        }
        return []
    }
}
