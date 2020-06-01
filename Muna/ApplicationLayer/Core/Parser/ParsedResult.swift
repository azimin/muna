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

enum CustomUnits: String, CaseIterable {
    case noon
    case afertnoon
    case evening
    case mindnight
    case morning
    case weekends
    case tomorrow
    case yesterday
    case tom
}

enum TagUnit: String {
    case ENTimeParser
    case ENWeekdaysParser
    case ENDatesPrefixParser
    case ENDatesPostfixParser
    case ENDaysParser
    case ENNumberDate
    case ENTimeHoursOffset
    case ENCustomWordsParser
    case ENTimeMintuesOffsetParser
    case ENMonthOffsetParser
}

struct ParsedResult {
    let refDate: Date

    var matchRange: NSRange
    var reservedComponents: [ReserverdUnit: Int]
    var customComponents: [String]
    var tagUnit: [TagUnit: Bool]
}

struct ParsedItem {
    var text: String
    let match: NSTextCheckingResult
    let refDate: Date
}
