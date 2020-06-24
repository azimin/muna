//
//  ReminderItem.swift
//  Muna
//
//  Created by Alexander on 5/24/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class ReminderItem {
    let date: Date?

    // left side
    let title: String
    let subtitle: String

    // right side
    let additionalText: String

    init(date: Date?, title: String, subtitle: String, additionalText: String) {
        self.date = date
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
                let offset = Float(60) / Float(minutes)
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
            }
        } else {
            additionalText = formatter.additionalText
        }

        self.init(
            date: transformedDate.date,
            title: formatter.monthDateWeekday,
            subtitle: formatter.subtitle,
            additionalText: additionalText
        )
    }
}
