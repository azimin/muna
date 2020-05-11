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

    func parse(fromText text: String, refDate: Date) -> ParsedItem? {
        let regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: self.pattern, options: .caseInsensitive)
        } catch {
            assertionFailure("Couldnt allocate regex: \(error)")
            return nil
        }

        guard let match = regex.firstMatch(in: text, range: NSRange(location: 0, length: text.count)) else {
            return nil
        }
        return ParsedItem(text: text, match: match, refDate: refDate)
    }

    func extract(fromParsedItem parsedItem: ParsedItem, toParsedResult results: [ParsedResult]) -> [ParsedResult] {
        return []
    }
}
