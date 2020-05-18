//
//  TimeType.swift
//  Muna
//
//  Created by Alexander on 5/18/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

enum TimeType {
    case noon
    case afertnoon
    case evening
    case mindnight
    case morning
    case specificTime(timeIntervalSinceBeggininOfDay: TimeOfDay)
    case allDay
}
