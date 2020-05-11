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
        return "\\b(?:(?:at)\\s*)?(([1-9]|1[0-9]|2[0-4]))(?:\\.|\\:|\\：)(\\d*)(?:\\s*(a\\.m\\.|p\\.m\\.|am?|pm?))?\\b"
    }

    let hourGroup = 1
    let minutesGroup = 2
    let partOfTheDayGroup = 3

    override func extract(fromText text: String, withMatch match: NSTextCheckingResult, refDate: Date) -> ParsedResult? {
        print(match.numberOfRanges)

        guard !match.isEmpty(atRangeIndex: self.hourGroup) else {
            return nil
        }

        let nowHours = refDate.hour
        let nowMinutes = refDate.minute
        let nowSeconds = refDate.second

        guard let hoursOffset = Int(match.string(from: text, atRangeIndex: self.hourGroup)) else {
            return nil
        }

        let minutesOffset = match.isEmpty(atRangeIndex: self.minutesGroup) ? 0 : Int(match.string(from: text, atRangeIndex: self.minutesGroup))

        let partOfTheDay = match.isEmpty(atRangeIndex: self.partOfTheDayGroup) ? "" : match.string(from: text, atRangeIndex: self.partOfTheDayGroup)
        return nil
    }
}
