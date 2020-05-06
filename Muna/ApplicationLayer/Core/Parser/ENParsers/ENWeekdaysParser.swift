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
//        let prefixGroup = match.string(from: text, atRangeIndex: 1)
        let prefixGroup = ""
        
        let weekdayGroup = match.string(from: text, atRangeIndex: 2)

        
        guard let dateOffset = self.weekDayOffset[weekdayGroup] else {
            return nil
        }
        
        let today = refDate.weekday

        var weekday: Int
        if dateOffset - today < 0 {
            weekday = (7 - today) + dateOffset
        } else {
            weekday = today - dateOffset
        }

        if prefixGroup == "next" {
            weekday += 7
        }

        print(refDate.added(weekday, .weekday).timeIntervalSince1970)
        
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

var cal: Calendar { return Calendar.current }
var utcCal: Calendar {
    var cal = Calendar(identifier: Calendar.Identifier.gregorian)
    cal.timeZone = utcTimeZone
    return cal
}
let utcTimeZone: TimeZone = TimeZone(identifier: "UTC")!

private let noneZeroComponents: Set<Calendar.Component> = [.year, .month, .day]

extension Date {
    
    func isAfter(_ other: Date) -> Bool {
        return self.timeIntervalSince1970 > other.timeIntervalSince1970
    }
    
    var year: Int { return cal.component(.year, from: self) }
    var month: Int { return cal.component(.month, from: self) }
    var day: Int { return cal.component(.day, from: self) }
    var hour: Int { return cal.component(.hour, from: self) }
    var minute: Int { return cal.component(.minute, from: self) }
    var second: Int { return cal.component(.second, from: self) }
    var millisecond: Int { return nanoSecondsToMilliseconds(cal.component(.nanosecond, from: self)) }
    var nanosecond: Int { return cal.component(.nanosecond, from: self) }
    var weekday: Int {
        // by default, start from 1. we mimic the moment.js' SPEC, start from 0
        return cal.component(.weekday, from: self) - 1
    }
    
    var utcYear: Int { return utcCal.component(.year, from: self) }
    var utcMonth: Int { return utcCal.component(.month, from: self) }
    var utcDay: Int { return utcCal.component(.day, from: self) }
    var utcHour: Int { return utcCal.component(.hour, from: self) }
    var utcMinute: Int { return utcCal.component(.minute, from: self) }
    var utcSecond: Int { return utcCal.component(.second, from: self) }
    var utcMillisecond: Int { return nanoSecondsToMilliseconds(utcCal.component(.nanosecond, from: self)) }
    var utcNanosecond: Int { return utcCal.component(.nanosecond, from: self) }
    var utcWeekday: Int {
        // by default, start from 1. we mimic the moment.js' SPEC, start from 0
        return utcCal.component(.weekday, from: self) - 1
    }
    
    /// ask number of day in the current month.
    ///
    /// e.g. the "unit" will be .day, the "baseUnit" will be .month
    func numberOf(_ unit: Calendar.Component, inA baseUnit: Calendar.Component) -> Int? {
        if let range = cal.range(of: unit, in: baseUnit, for: self) {
            return range.upperBound - range.lowerBound
        }
        
        return nil
    }
    
    func differenceOfTimeInterval(to date: Date) -> TimeInterval {
        return timeIntervalSince1970 - date.timeIntervalSince1970
    }
    
    /// offset minutes between UTC and current time zone, the value could be 60, 0, -60, etc.
    var utcOffset: Int {
        get {
            let timeZone = NSTimeZone.local
            let offsetSeconds = timeZone.secondsFromGMT(for: self)
            return offsetSeconds / 60
        }
        set {
            let interval = TimeInterval(newValue * 60)
            self = Date(timeInterval: interval, since: self)
        }
    }
    
    func added(_ value: Int, _ unit: Calendar.Component) -> Date {
        return cal.date(byAdding: unit, value: value, to: self)!
    }
}

func millisecondsToNanoSeconds(_ milliseconds: Int) -> Int {
    return milliseconds * 1000000
}

func nanoSecondsToMilliseconds(_ nanoSeconds: Int) -> Int {
    /// this convert is used to prevent from nanoseconds error
    /// test case, create a date with nanoseconds 11000000, and get it via Calendar.Component, you will get 10999998
    let doubleMs = Double(nanoSeconds) / 1000000
    let ms = Int(doubleMs)
    return doubleMs > Double(ms) ? ms + 1 : ms
}

