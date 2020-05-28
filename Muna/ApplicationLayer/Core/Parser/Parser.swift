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

    func parse(fromText text: String, refDate: Date, into items: [DateItem]) -> [DateItem] {
        let regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: self.pattern, options: .caseInsensitive)
        } catch {
            assertionFailure("Couldnt allocate regex: \(error)")
            return items
        }

        let matches = regex.matches(in: text, range: NSRange(location: 0, length: text.count))

        guard !matches.isEmpty else {
            return items
        }

        let parsedItems = matches.map { match in
            ParsedItem(text: text, match: match, refDate: refDate)
        }

        return parsedItems.map { self.extract(fromParsedItem: $0, toParsedResult: items) }.flatMap { $0 }
    }

    func extract(fromParsedItem parsedItem: ParsedItem, toParsedResult results: [DateItem]) -> [DateItem] {
        return []
    }
}
