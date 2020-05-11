//
//  ParsedResult.swift
//  Muna
//
//  Created by Egor Petrov on 05.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

enum ComponentUnit {
    case year, month, day, hour, minute, second, millisecond, weekday, timeZoneOffset, meridiem
}

enum TimeUnit: String {
    case noon
    case afertnoon
    case evening
    case mindnight
    case morning
    case specificTime
    case allDay
}

struct ParsedTime {
    let timeUnit: TimeUnit
    let hours: Int?
}

struct ParsedResult {
    var range: [NSRange]
    let date: Date
    var time: ParsedTime
}

struct ParsedItem {
    let text: String
    let match: NSTextCheckingResult
    let refDate: Date
}
