//
//  TimeOfDay.swift
//  Muna
//
//  Created by Alexander on 5/18/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

struct TimeOfDay {
    var timeIntervalSinceBeggininOfDay: TimeInterval

    init(timeIntervalSinceBeggininOfDay: TimeInterval) {
        self.timeIntervalSinceBeggininOfDay = timeIntervalSinceBeggininOfDay
    }

    init(hours: Int = 0, minutes: Int = 0, seconds: Int = 0) {
        self.timeIntervalSinceBeggininOfDay = TimeInterval(
            hours * 60 * 60 + minutes * 60 + seconds
        )
    }

    func apply(to pureDay: PureDay) -> Date {
        guard let date = "\(pureDay.day):\(pureDay.month):\(pureDay.year)".toDate("dd:MM:yyyy")?.date else {
            assertionFailure("No date")
            return Date()
        }

        return date.addingTimeInterval(self.timeIntervalSinceBeggininOfDay)
    }
}
