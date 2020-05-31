//
//  ENWeekdaysParser.swift
//  Muna
//
//  Created by Egor Petrov on 05.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation
import SwiftDate

class ENWeekdaysParser: Parser {
    private var days: String {
        return weekdays.keys.map { $0 }.joined(separator: "|")
    }

    override var pattern: String {
        return "\\b(?:on\\s*?)?(?:(next|this|after))?\\s*(\(self.days))\\b"
    }

    override func extract(fromParsedItem parsedItem: ParsedItem) -> ParsedResult? {
        let weekdayName = parsedItem.match.string(from: parsedItem.text, atRangeIndex: 2).lowercased()
        guard let weekdayOffset = weekdays[weekdayName] else {
            return nil
        }

        let today = parsedItem.refDate.weekday

        let prefixGroup = parsedItem.match.isEmpty(atRangeIndex: 1) ? "" : parsedItem.match.string(from: parsedItem.text, atRangeIndex: 1).lowercased()

        var weekday: Int
        if weekdayOffset - today < 0 {
            weekday = (7 - today) + weekdayOffset
        } else {
            weekday = weekdayOffset - today
        }

        if prefixGroup == "next" {
            weekday += 7
        }

        return ParsedResult(refDate: parsedItem.refDate, reservedComponents: [.weekday: weekday], customComponents: [:])
    }
}

extension NSTextCheckingResult {
    func isNotEmpty(atRangeIndex index: Int) -> Bool {
        return range(at: index).length != 0
    }

    func isEmpty(atRangeIndex index: Int) -> Bool {
        return range(at: index).length == 0
    }

    func string(from text: String, atRangeIndex index: Int) -> String {
        return text.subString(with: range(at: index))
    }
}

extension String {
    var firstString: String? {
        return self.substring(from: 0, to: 1)
    }

    func subString(with range: NSRange) -> String {
        return (self as NSString).substring(with: range)
    }

    func substring(from idx: Int) -> String {
        return String(self[index(startIndex, offsetBy: idx)...])
    }

    func substring(from startIdx: Int, to endIdx: Int? = nil) -> String {
        if startIdx < 0 || (endIdx != nil && endIdx! < 0) {
            return ""
        }
        let start = index(startIndex, offsetBy: startIdx)
        let end = endIdx != nil ? index(startIndex, offsetBy: endIdx!) : endIndex
        return String(self[start ..< end])
    }

    func range(ofStartIndex idx: Int, length: Int) -> Range<String.Index> {
        let startIndex0 = index(startIndex, offsetBy: idx)
        let endIndex0 = index(startIndex, offsetBy: idx + length)
        return Range(uncheckedBounds: (lower: startIndex0, upper: endIndex0))
    }

    func range(ofStartIndex startIdx: Int, andEndIndex endIdx: Int) -> Range<String.Index> {
        let startIndex0 = index(startIndex, offsetBy: startIdx)
        let endIndex0 = index(startIndex, offsetBy: endIdx)
        return Range(uncheckedBounds: (lower: startIndex0, upper: endIndex0))
    }

    func trimmed() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

let utcTimeZone: TimeZone = TimeZone(identifier: "UTC")!

private let noneZeroComponents: Set<Calendar.Component> = [.year, .month, .day]

func millisecondsToNanoSeconds(_ milliseconds: Int) -> Int {
    return milliseconds * 1_000_000
}

func nanoSecondsToMilliseconds(_ nanoSeconds: Int) -> Int {
    /// this convert is used to prevent from nanoseconds error
    /// test case, create a date with nanoseconds 11000000, and get it via Calendar.Component, you will get 10999998
    let doubleMs = Double(nanoSeconds) / 1_000_000
    let ms = Int(doubleMs)
    return doubleMs > Double(ms) ? ms + 1 : ms
}
