//
//  TimeParserTests.swift
//  Muna
//
//  Created by Alexander on 5/18/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation
import SwiftDate

class TimeParserTests {
    static func test() {
        let date = "05-21-2020 22:30".toDate("MM-dd-yyyy HH:mm")!.date
        print(date)

        // in 4h
        var value = DateProcesingService().getDate(from: "In 4h", date: date)
        assert(value.count == 1, "Should be one")
        self.validate(
            item: value.first!,
            day: .init(day: 22, month: 5, year: 2020),
            timeType: .specificTime(
                timeOfDay: .init(hours: 2, minutes: 30, seconds: 0)
            )
        )

        // in 1h
        value = DateProcesingService().getDate(from: "In 1h", date: date)
        assert(value.count == 1, "Should be one")
        self.validate(
            item: value.first!,
            day: .init(day: 21, month: 5, year: 2020),
            timeType: .specificTime(
                timeOfDay: .init(hours: 23, minutes: 30, seconds: 0)
            )
        )

        // Tomorrow
        value = DateProcesingService().getDate(from: "Tomorrow", date: date)
        assert(value.count == 1, "Should be one")
        self.validate(
            item: value.first!,
            day: .init(day: 22, month: 5, year: 2020),
            timeType: .allDay
        )

        // tomorrow
        value = DateProcesingService().getDate(from: "tomorrow", date: date)
        assert(value.count == 1, "Should be one")
        self.validate(
            item: value.first!,
            day: .init(day: 22, month: 5, year: 2020),
            timeType: .allDay
        )

        // weekends
        value = DateProcesingService().getDate(from: "weekends", date: date)
        assert(value.count >= 2, "Should be at least two")
        self.validate(
            item: value[0],
            day: .init(day: 23, month: 5, year: 2020),
            timeType: .allDay
        )

        self.validate(
            item: value[1],
            day: .init(day: 24, month: 5, year: 2020),
            timeType: .allDay
        )

        // weekends 5 pm
        value = DateProcesingService().getDate(from: "weekends 5 pm", date: date)
        assert(value.count >= 2, "Should be at least two")
        self.validate(
            item: value[0],
            day: .init(day: 23, month: 5, year: 2020),
            timeType: .specificTime(
                timeOfDay: .init(hours: 17, minutes: 00, seconds: 0)
            )
        )

        self.validate(
            item: value[1],
            day: .init(day: 24, month: 5, year: 2020),
            timeType: .specificTime(
                timeOfDay: .init(hours: 17, minutes: 00, seconds: 0)
            )
        )

        // on sun
        value = DateProcesingService().getDate(from: "on sun", date: date)
        assert(value.count > 2, "Should be at least 2")
        self.validate(
            item: value[0],
            day: .init(day: 24, month: 5, year: 2020),
            timeType: .allDay
        )

        self.validate(
            item: value[1],
            day: .init(day: 31, month: 5, year: 2020),
            timeType: .allDay
        )

        // Fri 20
        value = DateProcesingService().getDate(from: "Fri 20", date: date)
        assert(value.count >= 2, "Should be at least 2")
        self.validate(
            item: value[0],
            day: .init(day: 22, month: 5, year: 2020),
            timeType: .specificTime(
                timeOfDay: .init(hours: 20, minutes: 00, seconds: 0)
            )
        )

        self.validate(
            item: value[1],
            day: .init(day: 29, month: 5, year: 2020),
            timeType: .specificTime(
                timeOfDay: .init(hours: 20, minutes: 00, seconds: 0)
            )
        )

        // Next Friday 8 30 pm
        value = DateProcesingService().getDate(from: "Next Friday 8 30 pm", date: date)
        assert(value.count == 1, "Should be 1")
        self.validate(
            item: value[0],
            day: .init(day: 29, month: 5, year: 2020),
            timeType: .specificTime(
                timeOfDay: .init(hours: 20, minutes: 30, seconds: 0)
            )
        )

        // in 5 mins
        value = DateProcesingService().getDate(from: "in 5 mins", date: date)
        assert(value.count == 1, "Should be 1")
        self.validate(
            item: value[0],
            day: .init(day: 21, month: 5, year: 2020),
            timeType: .specificTime(
                timeOfDay: .init(hours: 22, minutes: 35, seconds: 0)
            )
        )

        // 20.06
        value = DateProcesingService().getDate(from: "20.06", date: date)
        assert(value.count > 1, "Should be at least 2")
        self.validate(
            item: value[0],
            day: .init(day: 20, month: 6, year: 2020),
            timeType: .allDay
        )

        // next month
        value = DateProcesingService().getDate(from: "next month", date: date)
        assert(value.count > 1, "Should be at least 1")
        self.validate(
            item: value[0],
            day: .init(day: 1, month: 6, year: 2020),
            timeType: .allDay
        )

        // mon morning
        value = DateProcesingService().getDate(from: "mon morning", date: date)
        assert(value.count > 1, "Should be at least 1")
        self.validate(
            item: value[0],
            day: .init(day: 25, month: 6, year: 2020),
            timeType: .morning
        )

        // 20 june
        value = DateProcesingService().getDate(from: "20 june", date: date)
        assert(value.count == 1, "Should be 1")
        self.validate(
            item: value[0],
            day: .init(day: 20, month: 6, year: 2020),
            timeType: .allDay
        )

        // tomorrow evening
        value = DateProcesingService().getDate(from: "tomorrow evening", date: date)
        assert(value.count == 1, "Should be 1")
        self.validate(
            item: value[0],
            day: .init(day: 22, month: 5, year: 2020),
            timeType: .evening
        )
    }

    static func validate(item: DateItem, day: PureDay, timeType: TimeType) {
        assert(item.day == day, "Wront item: \(item.day), expected day: \(day)")
        assert(item.timeType == timeType, "Wront item: \(item.timeType), expected time: \(timeType)")
    }
}
