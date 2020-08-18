//
//  TimeOfDay.swift
//  Muna
//
//  Created by Alexander on 5/18/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation
import SwiftDate

struct TimeOfDay: Equatable, Comparable {
    var hours: Int
    var minutes: Int
    var seconds: Int

    init(hours: Int = 0, minutes: Int = 0, seconds: Int = 0) {
        assert(hours >= 0 && hours < 24, "Hours 0..<24")
        assert(minutes >= 0 && minutes < 60, "Minutes 0..<24")
        assert(seconds >= 0 && seconds < 60, "Seconds 0..<24")

        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }

    func apply(to pureDay: PureDay) -> Date {
        let string = "\(pureDay.day):\(pureDay.month):\(pureDay.year) \(self.hours):\(self.minutes):\(self.seconds)"

        guard let date = string.toDate(
            "dd:MM:yyyy HH:mm:ss",
            region: .currentIn(
                locale: Locales.englishUnitedStates,
                calendar: Calendars.gregorian
            )
        )?.date.transformToClassicDate() else {
            appAssertionFailure("No date")
            return Date()
        }

        return date
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.hours == rhs.hours && lhs.minutes == rhs.minutes && lhs.seconds == rhs.seconds
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.hours < rhs.hours && lhs.minutes < rhs.minutes && lhs.seconds < rhs.seconds
    }

    static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.hours > rhs.hours && lhs.minutes > rhs.minutes && lhs.seconds > rhs.seconds
    }

    static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.hours <= rhs.hours && lhs.minutes <= rhs.minutes && lhs.seconds <= rhs.seconds
    }

    static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.hours >= rhs.hours && lhs.minutes >= rhs.minutes && lhs.seconds >= rhs.seconds
    }
}
