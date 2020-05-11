//
//  ParsedResult.swift
//  Muna
//
//  Created by Egor Petrov on 05.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

public enum ComponentUnit {
    case year, month, day, hour, minute, second, millisecond, weekday, timeZoneOffset, meridiem
}

struct ParsedResult {
    let range: NSRange

    let unit: [ComponentUnit: Int]
}
