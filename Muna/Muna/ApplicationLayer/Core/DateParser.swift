//
//  DateParser.swift
//  Muna
//
//  Created by Egor Petrov on 04.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

protocol DateParserProtocol {

    func parseDate(from string: String) -> [Date?]
}
class DateParser: DateParserProtocol {

    func parseDate(from string: String) -> [Date?] {
        let detector: NSDataDetector
        do {
            detector = try NSDataDetector(
                types: NSTextCheckingResult.CheckingType.date.rawValue
            )
        } catch {
            // TODO: - Make appAsserationHandler
            assertionFailure("Error on detector initialization: \(error)")
            return []
        }

        let matches = detector.matches(
            in: string,
            options: [],
            range: NSRange(location: 0, length: string.utf16.count)
        )

        let dates = matches.map { $0.date }
        return dates
    }
}
