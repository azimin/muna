//
//  MunaChrono.swift
//  Muna
//
//  Created by Egor Petrov on 12.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class MunaChrono {
    private let parsers = [ENWeekdaysParser(), ENTimeParser()]

    func parseFromString(_ string: String, date: Date) -> [DateItem] {
        var results = [DateItem]()
        self.parsers.forEach {
            results = $0.parse(fromText: string, refDate: date, into: results)
        }
        return results
    }
}
