//
//  ShortcutDateFormatter.swift
//  Muna
//
//  Created by Alexander on 5/21/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation
import SwiftDate

class ShortcutDateFormatter {
    private let date: Date

    init(date: Date) {
        self.date = date
    }

    var title: String {
        let month = self.date.representableDate().monthName(.short)
        let day = self.date.representableDate().ordinalDay
        let weekday = self.date.representableDate().weekdayName(.short)
        return "\(month), \(day) \(weekday)"
    }

    var subtitle: String {
        return self.date.representableDate().toFormat("HH:mm")
    }

    var additionalText: String {
        guard self.date > Date() else {
            return "passed"
        }

        guard let month = self.date.difference(in: .month, from: Date()),
            let days = self.date.difference(in: .day, from: Date()),
            let hours = self.date.difference(in: .hour, from: Date()),
            let minutes = self.date.difference(in: .minute, from: Date()) else {
            assertionFailure("Can't parse")
            return ""
        }

        if month > 0 {
            let sufix = month == 1 ? "month" : "months"
            return "in \(month) \(sufix)"
        }

        if days > 0 {
            let sufix = days == 1 ? "day" : "days"
            return "in \(days) \(sufix)"
        }

        if hours > 0 {
            let sufix = hours == 1 ? "hour" : "hours"
            return "in \(hours) \(sufix)"
        }

        if minutes > 0 {
            let sufix = minutes == 1 ? "minute" : "minutes"
            return "in \(minutes) \(sufix)"
        }

        return ""
    }
}

extension Date {
    func representableDate() -> Date {
        let format = DateFormatter()
        format.dateFormat = "MM-dd-yyyy HH:mm"
        let string = format.string(from: self)

        if let date = string.toDate("MM-dd-yyyy HH:mm") {
            return date.date
        } else {
            assertionFailure("Can't cast")
            return Date()
        }
    }
}
