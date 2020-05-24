//
//  ShortcutDateFormatter.swift
//  Muna
//
//  Created by Alexander on 5/21/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation
import SwiftDate

class DateParserFormatter {
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

        let comparsion = DateComparisonFormatter(date: self.date)
        return comparsion.comparisonText
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
