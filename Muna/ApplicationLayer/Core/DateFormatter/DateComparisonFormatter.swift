//
//  DateComparisonFormatter.swift
//  Muna
//
//  Created by Alexander on 5/24/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation
import SwiftDate

class DateComparisonFormatter {
    private let date: Date

    init(date: Date) {
        self.date = date
    }

    var comparisonText: String {
        let resultPrefix: String
        let resultSuffix: String
        var result: String = ""

        if self.date > Date() {
            resultPrefix = "in "
            resultSuffix = ""
        } else {
            resultPrefix = ""
            resultSuffix = " ago"
        }

        guard let month = self.date.difference(in: .month, from: Date()),
            let days = self.date.difference(in: .day, from: Date()),
            let hours = self.date.difference(in: .hour, from: Date()),
            let minutes = self.date.difference(in: .minute, from: Date()),
            let seconds = self.date.difference(in: .second, from: Date()) else {
            assertionFailure("Can't parse")
            return ""
        }

        if month > 0 {
            let sufix = month == 1 ? "month" : "months"
            let value = self.roundValue(
                number: month,
                correctionNumber: days,
                correctionType: .days
            )
            result = "\(value) \(sufix)"
        } else if days > 0 {
            let sufix = days == 1 ? "day" : "days"
            let value = self.roundValue(
                number: days,
                correctionNumber: hours,
                correctionType: .hours
            )
            result = "in \(value) \(sufix)"
        } else if hours > 0 {
            let sufix = hours == 1 ? "hour" : "hours"
            let value = self.roundValue(
                number: hours,
                correctionNumber: minutes,
                correctionType: .minutes
            )
            result = "in \(value) \(sufix)"
        } else if minutes > 0 {
            let sufix = minutes == 1 ? "minute" : "minutes"
            let value = self.roundValue(
                number: minutes,
                correctionNumber: seconds,
                correctionType: .seconds
            )
            result = "in \(value) \(sufix)"
        } else {
            return ""
        }

        return resultPrefix + result + resultSuffix
    }

    private enum ValueType {
        case days
        case hours
        case minutes
        case seconds
    }

    private func roundValue(number: Int, correctionNumber: Int, correctionType: ValueType) -> Int {
        switch correctionType {
        case .days:
            return number
        case .hours:
            return (correctionNumber - number * 24) > 12 ? number + 1 : number
        case .minutes:
            return (correctionNumber - number * 60) > 30 ? number + 1 : number
        case .seconds:
            return (correctionNumber - number * 60) > 30 ? number + 1 : number
        }
    }
}
