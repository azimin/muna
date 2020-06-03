//
//  DateProcessingService.swift
//  Muna
//
//  Created by Egor Petrov on 02.06.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation
import SwiftDate

class DateProcesingService {
    private let parser = MunaChrono()

    let numberOfAvailableDays = 3

    func getDate(from string: String, date: Date) -> [DateItem] {
        let parsedResults = self.parser.parseFromString(string, date: date)

        let items = parsedResults.map { result -> [DateItem] in
            if result.tagUnit.keys.contains(.ENWeekdaysParser) {
                return mapFromWeekdays(result)
            }

            return mapFromDate(result)
        }
        .flatMap { $0 }
        return items
    }

    func mapFromWeekdays(_ result: ParsedResult) -> [DateItem] {
        return (0 ... self.numberOfAvailableDays).compactMap { numberOfElement in
            guard
                let day = result.reservedComponents[.day],
                let month = result.reservedComponents[.month],
                let year = result.reservedComponents[.year]
            else {
                assertionFailure("One of the element doesn't provided")
                return nil
            }

            let hour = result.reservedComponents[.hour] ?? 0
            let minute = result.reservedComponents[.minute] ?? 0

            let timeOfDay = TimeOfDay(hours: hour, minutes: minute)

            var pureDay = PureDay(day: day, month: month, year: year)
            let newDate = timeOfDay.apply(to: pureDay) + (numberOfElement * 7).days
            pureDay = PureDay(day: newDate.day, month: newDate.month, year: newDate.year)

            if result.reservedComponents[.hour] != nil, result.reservedComponents[.minute] != nil {
                return DateItem(day: pureDay, timeType: .specificTime(timeOfDay: timeOfDay))
            } else {
                return DateItem(day: pureDay, timeType: .allDay)
            }
        }
    }

    func mapFromDate(_ result: ParsedResult) -> [DateItem] {
        guard
            let day = result.reservedComponents[.day],
            let month = result.reservedComponents[.month],
            let year = result.reservedComponents[.year]
        else {
            assertionFailure("One of the element doesn't provided")
            return []
        }

        let pureDay = PureDay(day: day, month: month, year: year)

        guard
            let hour = result.reservedComponents[.hour],
            let minute = result.reservedComponents[.minute]
        else {
            return [DateItem(day: pureDay, timeType: .allDay)]
        }

        let timeOfDay = TimeOfDay(hours: hour, minutes: minute)

        return [DateItem(day: pureDay, timeType: .specificTime(timeOfDay: timeOfDay))]
    }
}
