//
//  ENCustomWordsParser.swift
//  Muna
//
//  Created by Egor Petrov on 01.06.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class ENCustomWordsParser: Parser {
    var customUnits: String {
        return CustomUnits.allCases.map { $0.rawValue }.joined(separator: "|")
    }

    override var pattern: String {
        "\\b(s*(\(self.customUnits)))\\b"
    }

    let wordItem = 1

    override func extract(fromParsedItem parsedItem: ParsedItem) -> ParsedResult? {
        guard !parsedItem.match.isEmpty(atRangeIndex: self.wordItem) else {
            return nil
        }

        let word = parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.wordItem).lowercased()

        return ParsedResult(
            refDate: parsedItem.refDate,
            matchRange: parsedItem.match.range,
            reservedComponents: [:],
            customComponents: [word],
            tagUnit: [.ENCustomWordsParser: true]
        )
    }
}
