//
//  ENWeekdaysParser.swift
//  Muna
//
//  Created by Egor Petrov on 05.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class ENWeekdaysParser: Parser {

    private let weekDayOffset = [
        "sunday": 0,
        "sun": 0,
        "monday": 1,
        "mon": 1,
        "tuesday": 2,
        "tue": 2,
        "wednesday": 3,
        "wed": 3,
        "thursday": 4,
        "thurs": 4,
        "thur": 4,
        "thu": 4,
        "friday": 5,
        "fri": 5,
        "saturday": 6,
        "sat": 6
    ]

    private var days: String {
        return self.weekDayOffset.keys.map { $0 }.joined(separator: "|")
    }

    override var pattern: String {
        return "\\b(?:on\\s*?)?(?:(next|this))?\\s*(\(days))\\b"
    }

    override func extract(fromText text: String, withMatch match: NSTextCheckingResult, refDate: Date) -> ParsedResult? {
        let matchedSubstring = text.subString(with: match.range)
        print(match.numberOfRanges)
        print(match.string(from: text, atRangeIndex: 2))
        return nil
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
        return substring(from: 0, to: 1)
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
            return String(self[start..<end])
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
