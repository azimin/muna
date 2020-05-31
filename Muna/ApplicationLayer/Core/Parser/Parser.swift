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

    func parse(fromText text: String, refDate: Date) -> [ParsedResult] {
        let regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: self.pattern, options: .caseInsensitive)
        } catch {
            assertionFailure("Couldnt allocate regex: \(error)")
            return []
        }
        var results = [ParsedResult]()

        let matches = regex.matches(in: text, range: NSRange(location: 0, length: text.count))
        matches.forEach {
            let item = ParsedItem(text: text, match: $0, refDate: refDate)
            guard let parsedResult = self.extract(fromParsedItem: item) else {
                return
            }
            results.append(parsedResult)
        }
        return results
    }

    func extract(fromParsedItem parsedItem: ParsedItem) -> ParsedResult? {
        return nil
    }
}
