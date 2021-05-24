//
//  ENCustomPartOfTheDayWordsParser.swift
//  Muna
//
//  Created by Egor Petrov on 02.06.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class ENCustomPartOfTheDayWordsParser: Parser {
    var customUnits: String {
        return CustomDayPartWords.allCases.map { $0.rawValue }.joined(separator: "|")
    }

    override var pattern: String {
        "\\b(s*(\(self.customUnits)))\\b"
    }

    let wordItem = 1

    override func parse(fromText text: String, refDate: Date) -> [ParsedResult] {
        let regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: self.pattern, options: .caseInsensitive)
        } catch {
            appAssertionFailure("Couldnt allocate regex: \(error)")
            return []
        }
        var results = [ParsedResult]()

        let matches = regex.matches(in: text, range: NSRange(location: 0, length: text.count))
        
        if matches.isEmpty && text.lowercased().contains(CustomDayPartWords.evening.rawValue.lowercased()) {
            assertionFailure("Cannot parse evening in ENCustomPartOfTheDayWordsParser")
        }

        matches.forEach {
            let item = ParsedItem(text: text, match: $0, refDate: refDate)
            guard let parsedResult = self.extract(fromParsedItem: item) else {
                return
            }
            results.append(parsedResult)
        }
        return results
    }

    override func extract(fromParsedItem parsedItem: ParsedItem) -> ParsedResult? {
        guard !parsedItem.match.isEmpty(atRangeIndex: self.wordItem) else {
            if parsedItem.text.lowercased().contains(CustomDayPartWords.evening.rawValue.lowercased()) {
                appAssertionFailure("Cannot etract result: \(parsedItem)")
            }
            return nil
        }

        let word = parsedItem.match.string(from: parsedItem.text, atRangeIndex: self.wordItem).lowercased()

        guard let partOfTheDayComponent = CustomDayPartWords(rawValue: word) else {
            return nil
        }

        return ParsedResult(
            refDate: parsedItem.refDate,
            matchRange: parsedItem.match.range,
            length: parsedItem.match.range.length,
            reservedComponents: [:],
            customDayComponents: [],
            customPartOfTheDayComponents: [partOfTheDayComponent],
            tagUnit: [.ENCustomPartOfTheDayWordsParser: true]
        )
    }
}
