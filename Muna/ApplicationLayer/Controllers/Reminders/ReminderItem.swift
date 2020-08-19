//
//  ReminderItem.swift
//  Muna
//
//  Created by Alexander on 5/24/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class ReminderItem {
    enum Value {
        case canNotFind
        case noItem
        case date(date: Date?)
    }

    let value: Value

    // left side
    let title: String
    let subtitle: String

    // right side
    let additionalText: String

    init(value: Value, title: String, subtitle: String, additionalText: String) {
        self.value = value
        self.title = title
        self.subtitle = subtitle
        self.additionalText = additionalText
    }

    convenience init(transformedDate: TransformedDate) {
        let formatter = DateParserFormatter(
            date: transformedDate.date
        )

        let additionalText: String
        if let offset = transformedDate.offset, transformedDate.date > Date() {
            switch offset {
            case let .day(days):
                let sufix = days == 1 ? "day" : "days"
                additionalText = "in \(days) \(sufix)"
            case let .minuts(minutes):
                let sufix = minutes == 1 ? "minute" : "minutes"
                additionalText = "in \(minutes) \(sufix)"
            case let .hour(hour, minutes):
                let offset = minutes == 0 ? 0 : Float(60) / Float(minutes)
                let offsetRounded = Int(round(offset * 10))
                let sufix = (hour == 1 && offsetRounded == 0) ? "hour" : "hours"

                let string: String
                if offsetRounded == 0 {
                    string = "\(hour)"
                } else if offsetRounded >= 1 {
                    string = "\(hour + 1)"
                } else {
                    string = "\(hour).\(offsetRounded)"
                }
                additionalText = "in \(string) \(sufix)"
            case let .month(month):
                let sufix = month == 1 ? "month" : "months"
                additionalText = "in \(month) \(sufix)"
            case let .week(week):
                let sufix = week == 1 ? "week" : "weeks"
                additionalText = "in \(week) \(sufix)"
            }
        } else {
            additionalText = formatter.additionalText
        }

        self.init(
            value: .date(date: transformedDate.date),
            title: formatter.monthDateWeekday,
            subtitle: formatter.subtitle,
            additionalText: additionalText
        )
    }
}
