//
//  DateItem.swift
//  Muna
//
//  Created by Alexander on 5/18/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

struct DateItem {
    var day: PureDay
    var timeType: TimeType
}

struct PureDay {
    var day: Int
    var month: Int
    var year: Int
}

enum TimeType {
    case noon
    case afertnoon
    case evening
    case mindnight
    case morning
    case specificTime(timeOfDay: TimeOfDay)
    case allDay
}
