//
//  TimeOfDay.swift
//  Muna
//
//  Created by Alexander on 5/18/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

struct TimeOfDay {
    var hours: Int
    var minutes: Int
    var seconds: Int

    init(hours: Int = 0, minutes: Int = 0, seconds: Int = 0) {
        if minutes > 59 {
            print("Swag")
        }
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }

    func apply(to pureDay: PureDay) -> Date {
        let string = "\(pureDay.day):\(pureDay.month):\(pureDay.year) \(self.hours):\(self.minutes):\(self.seconds)"

        guard let date = string.toDate("dd:MM:yyyy HH:mm:ss")?.date else {
            assertionFailure("No date")
            return Date()
        }

        return date
    }
}
