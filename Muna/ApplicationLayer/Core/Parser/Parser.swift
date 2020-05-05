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


    func parse(fromText text: String, refDate: Date) -> ParsedResult? {
        let regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        } catch {
            assertionFailure("Couldnt allocate regex: \(error)")
            return nil
        }

        guard let match = regex.firstMatch(in: text, range: NSRange(location: 0, length: text.count)) else {
            return nil
        }
        return self.extract(fromMatch: match, refDate: refDate)
    }

    func extract(fromMatch match: NSTextCheckingResult, refDate: Date) -> ParsedResult? {
        return nil
    }
}
