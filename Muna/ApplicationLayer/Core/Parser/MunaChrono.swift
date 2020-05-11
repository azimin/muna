//
//  MunaChrono.swift
//  Muna
//
//  Created by Egor Petrov on 12.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class MunaChrono {
    private let parsers = [ENTimeParser(), ENWeekdaysParser()]

    func parseFromString(_ string: String, date: Date) -> [ParsedResult] {
        var results = [ParsedResult]()
        self.parsers.forEach {
            results = $0.parse(fromText: string, refDate: date, into: results)
        }
        return results
    }
}
