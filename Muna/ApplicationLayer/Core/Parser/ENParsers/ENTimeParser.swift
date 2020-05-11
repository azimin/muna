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
        return "\\b(?:(?:at)\\s*)?(([1-9]|1[0-9]|2[0-4]))(((?:\\.|\\:|\\：)([0-5][0-9]))?)(?:\\s*(a\\.m\\.|p\\.m\\.|am?|pm?))?\\b"
    }

    let hourGroup = 1
    let minutesGroup = 5
    let partOfTheDayGroup = 6

    override func extract(fromText text: String, withMatch match: NSTextCheckingResult, refDate: Date) -> ParsedResult? {
        print(match.numberOfRanges)

        guard !match.isEmpty(atRangeIndex: self.hourGroup) else {
            return nil
        }

        guard var hoursOffset = Int(match.string(from: text, atRangeIndex: self.hourGroup)) else {
            return nil
        }
        print(hoursOffset)

        let partOfTheDay = match.isEmpty(atRangeIndex: self.partOfTheDayGroup) ? "" : match.string(from: text, atRangeIndex: self.partOfTheDayGroup)

        if !partOfTheDay.isEmpty, partOfTheDay == "pm", hoursOffset <= 12 {
            hoursOffset += 12
        }

        var minutesOffset = 0
        if !match.isEmpty(atRangeIndex: self.minutesGroup), let minutes = Int(match.string(from: text, atRangeIndex: self.minutesGroup)) {
            minutesOffset = minutes
        }

        let result = ParsedResult(
            range: match.range,
            unit:
            [
                .hour: hoursOffset,
                .minute: minutesOffset,
            ]
        )
        return result
    }
}
