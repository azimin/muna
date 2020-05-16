//
//  Parser.swift
//  Muna
//
//  Created by Egor Petrov on 05.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class Parser: ParserProtocol {
    var pattern: String {
        return ""
    }

    func parse(fromText text: String, refDate: Date, into items: [ParsedResult]) -> [ParsedResult] {
        let regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: self.pattern, options: .caseInsensitive)
        } catch {
            assertionFailure("Couldnt allocate regex: \(error)")
            return items
        }

        guard let match = regex.firstMatch(in: text, range: NSRange(location: 0, length: text.count)) else {
            return items
        }
        let item = ParsedItem(text: text, match: match, refDate: refDate)
        return self.extract(fromParsedItem: item, toParsedResult: items)
    }

    func extract(fromParsedItem parsedItem: ParsedItem, toParsedResult results: [ParsedResult]) -> [ParsedResult] {
        return []
    }
}
