//
//  DateItem.swift
//  Muna
//
//  Created by Alexander on 5/18/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

struct DateItem {
    var day: PureDay
    var timeType: TimeType
}

struct PureDay: Equatable {
    var day: Int
    var month: Int
    var year: Int

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.day == rhs.day && lhs.month == rhs.month && lhs.year == rhs.year
    }
}

enum TimeType: Equatable {
    case noon
    case afertnoon
    case evening
    case mindnight
    case morning
    case specificTime(timeOfDay: TimeOfDay)
    case allDay

    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.noon, .noon):
            return true
        case (.afertnoon, .afertnoon):
            return true
        case (.evening, .evening):
            return true
        case (.mindnight, .mindnight):
            return true
        case (.morning, .morning):
            return true
        case (.allDay, .allDay):
            return true
        case let (.specificTime(value), .specificTime(value2)):
            return value == value2
        default:
            return false
        }
    }
}
