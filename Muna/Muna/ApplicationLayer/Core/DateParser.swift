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

    private let datePattern = "\\b(\\w*(in)\\w*) (\\d?)(\\w*|(\\w+\\-\\w*)|(\\w* \\w*))(\\w*(minute|minutes|hour|hours|h|h.))\\b"

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

    private func tryFindByRegularExpression(from string: String) -> [Date?] {
        let detector: NSRegularExpression
        do {
            detector = try NSRegularExpression(pattern: self.datePattern, options: [NSRegularExpression.Options.caseInsensitive])
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

        return []
    }
}
