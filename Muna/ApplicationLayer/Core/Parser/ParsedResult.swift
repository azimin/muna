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

enum CustomUnits: CaseIterable {
    case noon
    case afertnoon
    case evening
    case mindnight
    case morning
    case weekends
    case tomorrow
    case allDay
}

struct ParsedResult {
    var refDate: Date

    var reservedComponents: [ReserverdUnit: Int]
    var customComponents: [CustomUnits: String]
}

struct ParsedItem {
    var text: String
    let match: NSTextCheckingResult
    let refDate: Date
}
