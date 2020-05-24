//
//  CardPreviewDateFormatter.swift
//  Muna
//
//  Created by Alexander on 5/24/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation
import SwiftDate

class CardPreviewDateFormatter {
    private let date: Date

    init(date: Date) {
        self.date = date
    }

    var reminderText: String {
        let suffix: String

        if self.timeTillEvent.isEmpty {
            suffix = ""
        } else {
            suffix = " (\(self.timeTillEvent))"
        }

        let value: String

        if self.date.isToday {
            value = "Today, \(self.time)"
        } else if self.date.isYesterday {
            value = "Yesterday, \(self.time)"
        } else if self.date.isTomorrow {
            value = "Tomorrow, \(self.time)"
        } else {
            value = "\(self.monthDayWeeday) \(self.time)"
        }

        return "\(value)\(suffix)"
    }

    var monthDayWeeday: String {
        let month = self.date.representableDate().monthName(.short)
        let day = self.date.representableDate().ordinalDay
        let weekday = self.date.representableDate().weekdayName(.short)
        return "\(month), \(day) \(weekday)"
    }

    var time: String {
        return self.date.representableDate().toFormat("HH:mm")
    }

    var timeTillEvent: String {
        let comparsion = DateComparisonFormatter(date: self.date)
        return comparsion.comparisonText
    }
}
