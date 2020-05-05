//
//  ENWeekdaysParser.swift
//  Muna
//
//  Created by Egor Petrov on 05.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class ENWeekdaysParser: Parser {

    private let weekDayOffset = [
        "sunday": 0,
        "sun": 0,
        "monday": 1,
        "mon": 1,
        "tuesday": 2,
        "tue": 2,
        "wednesday": 3,
        "wed": 3,
        "thursday": 4,
        "thurs": 4,
        "thur": 4,
        "thu": 4,
        "friday": 5,
        "fri": 5,
        "saturday": 6,
        "sat": 6
    ]

    private var days: String {
        return self.weekDayOffset.keys.map { $0 }.joined(separator: "|")
    }

    override var pattern: String {
        return "\\b(?:on\\s*?)?(?:(on|next|this))?\\s*(\(days)\\b"
    }
}
