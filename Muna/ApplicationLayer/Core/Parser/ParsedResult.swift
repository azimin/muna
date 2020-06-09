//
//  ParsedResult.swift
//  Muna
//
//  Created by Egor Petrov on 05.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

enum ReserverdUnit: CaseIterable {
    case year, month, day, hour, minute, weekday, partOfTheDay
}

let weekdays = [
    "sunday": 1,
    "sun": 1,
    "monday": 2,
    "mon": 2,
    "tuesday": 3,
    "tue": 3,
    "wednesday": 4,
    "wed": 4,
    "thursday": 5,
    "thurs": 5,
    "thur": 5,
    "thu": 5,
    "friday": 6,
    "fri": 6,
    "saturday": 7,
    "sat": 7,
]

enum CustomDayWords: String, CaseIterable {
    case weekends
    case tomorrow
    case yesterday
    case tom

    static var day: Set<String> {
        return [
            CustomDayWords.weekends.rawValue,
            CustomDayWords.tom.rawValue,
            CustomDayWords.tomorrow.rawValue,
            CustomDayWords.yesterday.rawValue,
        ]
    }
}

enum CustomDayPartWords: String, CaseIterable {
    case noon
    case afertnoon
    case evening
    case mindnight
    case morning

    static var partOfTheDay: Set<String> {
        return [
            CustomDayPartWords.noon.rawValue,
            CustomDayPartWords.afertnoon.rawValue,
            CustomDayPartWords.evening.rawValue,
            CustomDayPartWords.mindnight.rawValue,
            CustomDayPartWords.morning.rawValue,
        ]
    }
}

enum TagUnit: String {
    case ENTimeParser
    case ENWeekdaysParser
    case ENDatesPrefixParser
    case ENDatesPostfixParser
    case ENDaysParser
    case ENNumberDate
    case ENTimeHoursOffset
    case ENCustomDayWordsParser
    case ENCustomPartOfTheDayWordsParser
    case ENTimeMintuesOffsetParser
    case ENMonthOffsetParser
}

enum DatePrefix: String, CaseIterable {
    case next
    case this
    case after
    case past
}

struct ParsedResult {
    let refDate: Date

    var matchRange: NSRange
    var reservedComponents: [ReserverdUnit: Int]
    var customDayComponents: [CustomDayWords]
    var customPartOfTheDayComponents: [CustomDayPartWords]
    var tagUnit: [TagUnit: Bool]
    var prefix: DatePrefix?
}

struct ParsedItem {
    var text: String
    let match: NSTextCheckingResult
    let refDate: Date
}
