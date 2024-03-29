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

    private let weekendsOffset = [7, 1]

    func getDate(from string: String, date: Date) -> [DateItem] {
        let parsedResults = self.parser.parseFromString(string, date: date)

        var items = parsedResults.map { result -> [DateItem] in
            if result.tagUnit.keys.contains(.ENWeekdaysParser) {
                return mapFromWeekdays(result)
            }

            if result.tagUnit.keys.contains(where: {
                $0 != .ENCustomPartOfTheDayWordsParser && $0 != .ENCustomDayWordsParser
            }) {
                return mapFromDate(result)
            }

            return mapFromCustomWords(result)
        }
        .flatMap { $0 }

        items.sort { firstItem, secondItem in
            guard let firstOffset = firstItem.offset, let secondOffset = secondItem.offset else {
                return false
            }
            return firstOffset > secondOffset
        }
        return items
    }

    func mapFromWeekdays(_ result: ParsedResult) -> [DateItem] {
        guard result.prefix == nil else {
            guard
                let day = result.reservedComponents[.day],
                let month = result.reservedComponents[.month],
                let year = result.reservedComponents[.year]
            else {
                appAssertionFailure("One of the element doesn't provided")
                return []
            }

            let hour = result.reservedComponents[.hour] ?? 0
            let minute = result.reservedComponents[.minute] ?? 0

            var timeOfDay = TimeOfDay(hours: hour, minutes: minute)

            var pureDay = PureDay(day: day, month: month, year: year)

            if result.reservedComponents[.hour] != nil, result.reservedComponents[.minute] != nil {
                var dateItems = [DateItem]()
                if pureDay.day == result.refDate.day, hour < result.refDate.hour {
                    if hour < result.refDate.hour, hour < 12 {
                        timeOfDay.hours += 12
                        dateItems.append(DateItem(day: pureDay, timeType: .specificTime(timeOfDay: timeOfDay), offset: result.dateOffset))
                        timeOfDay.hours -= 12
                    }

                    if hour < result.refDate.hour {
                        pureDay.day += 1
                        dateItems.append(DateItem(day: pureDay, timeType: .specificTime(timeOfDay: timeOfDay), offset: result.dateOffset))
                        pureDay.day -= 1
                    }
                } else {
                    dateItems.append(DateItem(day: pureDay, timeType: .specificTime(timeOfDay: timeOfDay), offset: result.dateOffset))
                }

                return dateItems
            }

            guard !result.customPartOfTheDayComponents.isEmpty else {
                return [DateItem(day: pureDay, timeType: .allDay, offset: result.dateOffset)]
            }

            return result.customPartOfTheDayComponents.map {
                let timeType: TimeType
                switch $0 {
                case .afertnoon:
                    timeType = .afertnoon
                case .evening:
                    timeType = .evening
                case .mindnight:
                    timeType = .mindnight
                case .morning:
                    timeType = .morning
                case .noon:
                    timeType = .noon
                }

                return DateItem(day: pureDay, timeType: timeType, offset: result.dateOffset)
            }
        }
        let items = (0 ... self.numberOfAvailableDays).compactMap { numberOfElement -> [DateItem] in
            guard
                let day = result.reservedComponents[.day],
                let month = result.reservedComponents[.month],
                let year = result.reservedComponents[.year]
            else {
                appAssertionFailure("One of the element doesn't provided")
                return []
            }

            let hour = result.reservedComponents[.hour] ?? 0
            let minute = result.reservedComponents[.minute] ?? 0

            var timeOfDay = TimeOfDay(hours: hour, minutes: minute)

            var pureDay = PureDay(day: day, month: month, year: year)
            let newDate = timeOfDay.apply(to: pureDay) + (numberOfElement * 7).days
            pureDay = PureDay(date: newDate)

            if result.reservedComponents[.hour] != nil, result.reservedComponents[.minute] != nil {
                var dateItems = [DateItem]()
                if pureDay.day == result.refDate.day, hour < result.refDate.hour {
                    if hour < result.refDate.hour, hour < 12 {
                        timeOfDay.hours += 12
                        dateItems.append(DateItem(day: pureDay, timeType: .specificTime(timeOfDay: timeOfDay), offset: result.dateOffset))
                        timeOfDay.hours -= 12
                    }

                    if hour < result.refDate.hour {
                        pureDay.day += 1
                        dateItems.append(DateItem(day: pureDay, timeType: .specificTime(timeOfDay: timeOfDay), offset: result.dateOffset))
                        pureDay.day -= 1
                    }
                } else {
                    dateItems.append(DateItem(day: pureDay, timeType: .specificTime(timeOfDay: timeOfDay), offset: result.dateOffset))
                }

                return dateItems
            }

            guard !result.customPartOfTheDayComponents.isEmpty else {
                return [DateItem(day: pureDay, timeType: .allDay, offset: result.dateOffset)]
            }

            return result.customPartOfTheDayComponents.map {
                let timeType: TimeType
                switch $0 {
                case .afertnoon:
                    timeType = .afertnoon
                case .evening:
                    timeType = .evening
                case .mindnight:
                    timeType = .mindnight
                case .morning:
                    timeType = .morning
                case .noon:
                    timeType = .noon
                }

                return DateItem(day: pureDay, timeType: timeType, offset: result.dateOffset)
            }
        }

        return items.flatMap { $0 }
    }

    func mapFromDate(_ result: ParsedResult) -> [DateItem] {
        guard
            let day = result.reservedComponents[.day],
            let month = result.reservedComponents[.month],
            let year = result.reservedComponents[.year]
        else {
            appAssertionFailure("One of the element doesn't provided")
            return []
        }

        var pureDay = PureDay(day: day, month: month, year: year)

        if let hour = result.reservedComponents[.hour], let minute = result.reservedComponents[.minute] {
            var timeOfDay = TimeOfDay(hours: hour, minutes: minute)
            var dateItems = [DateItem]()
            if pureDay.day == result.refDate.day, hour < result.refDate.hour {
                if hour < result.refDate.hour, hour < 12 {
                    timeOfDay.hours += 12
                    dateItems.append(DateItem(day: pureDay, timeType: .specificTime(timeOfDay: timeOfDay), offset: result.dateOffset))
                    timeOfDay.hours -= 12
                }

                if hour < result.refDate.hour {
                    pureDay.day += 1
                    dateItems.append(DateItem(day: pureDay, timeType: .specificTime(timeOfDay: timeOfDay), offset: result.dateOffset))
                    pureDay.day -= 1
                }
            } else {
                dateItems.append(DateItem(day: pureDay, timeType: .specificTime(timeOfDay: timeOfDay), offset: result.dateOffset))
            }

            return dateItems
        }

        guard !result.customPartOfTheDayComponents.isEmpty else {
            return [DateItem(day: pureDay, timeType: .allDay, offset: result.dateOffset)]
        }

        return result.customPartOfTheDayComponents.map {
            let timeType: TimeType
            switch $0 {
            case .afertnoon:
                timeType = .afertnoon
            case .evening:
                timeType = .evening
            case .mindnight:
                timeType = .mindnight
            case .morning:
                timeType = .morning
            case .noon:
                timeType = .noon
            }

            return DateItem(day: pureDay, timeType: timeType, offset: result.dateOffset)
        }
    }

    func mapFromCustomWords(_ parsedResult: ParsedResult) -> [DateItem] {
        let pureDays = parsedResult.customDayComponents.map { dayComponent -> [PureDay] in
            let date: [Date]
            switch dayComponent {
            case .fortnight:
                date = [parsedResult.refDate + 2.weeks]
            case .tomorrow:
                var additionalDay = 0
                if let prefix = parsedResult.prefix, prefix == .after {
                    additionalDay = 1
                }
                if parsedResult.refDate.hour < 6 {
                    date = [
                        parsedResult.refDate + additionalDay.days,
                        parsedResult.refDate + 1.days + additionalDay.days,
                    ]
                } else {
                    date = [
                        parsedResult.refDate + 1.days + additionalDay.days,
                    ]
                }
            case .today:
                date = [parsedResult.refDate]
            case .yesterday:
                date = [parsedResult.refDate - 1.days]
            case .weekends:
                date = self.makeWeekendsFromDate(parsedResult.refDate, prefix: parsedResult.prefix)
            case .none:
                date = []
            }
            return date.map {
                return PureDay(day: $0.day, month: $0.month, year: $0.year)
            }
        }

        if let hour = parsedResult.reservedComponents[.hour], let minute = parsedResult.reservedComponents[.minute] {
            let timeOfDay = TimeOfDay(hours: hour, minutes: minute)
            return pureDays
                .flatMap { $0 }
                .map {
                    if $0.day == parsedResult.refDate.day, hour < parsedResult.refDate.hour {
                        return PureDay(day: $0.day + 1, month: $0.month, year: $0.year)
                    } else {
                        return $0
                    }
                }
                .map { DateItem(day: $0, timeType: .specificTime(timeOfDay: timeOfDay), offset: parsedResult.dateOffset) }
        }

        guard !parsedResult.customPartOfTheDayComponents.isEmpty else {
            return pureDays
                .flatMap { $0 }
                .map { DateItem(day: $0, timeType: .allDay, offset: parsedResult.dateOffset) }
        }

        let newPureDays = pureDays.flatMap { $0 }

        var finalResult = [DateItem]()
        if newPureDays.isEmpty {
            finalResult = parsedResult.customPartOfTheDayComponents.map {
                let timeType: TimeType
                switch $0 {
                case .afertnoon:
                    timeType = .afertnoon
                case .evening:
                    timeType = .evening
                case .mindnight:
                    timeType = .mindnight
                case .morning:
                    timeType = .morning
                case .noon:
                    timeType = .noon
                }
                return DateItem(day: PureDay(date: parsedResult.refDate), timeType: timeType, offset: parsedResult.dateOffset)
            }
        } else {
            parsedResult.customPartOfTheDayComponents.forEach { partOfTheDay in
                newPureDays.forEach {
                    let timeType: TimeType
                    switch partOfTheDay {
                    case .afertnoon:
                        timeType = .afertnoon
                    case .evening:
                        timeType = .evening
                    case .mindnight:
                        timeType = .mindnight
                    case .morning:
                        timeType = .morning
                    case .noon:
                        timeType = .noon
                    }

                    finalResult.append(DateItem(day: $0, timeType: timeType, offset: parsedResult.dateOffset))
                }
            }
        }

        return finalResult
    }

    func makeWeekendsFromDate(_ date: Date, prefix: DatePrefix?) -> [Date] {
        return self.weekendsOffset.map { weekendDay in
            var weekday: Int
            if weekendDay - date.weekday < 0 {
                weekday = (7 - date.weekday) + weekendDay
            } else {
                weekday = weekendDay - date.weekday
            }

            if let prefix = prefix, prefix == .next {
                weekday += 7
            }

            return date + weekday.days
        }
    }
}
