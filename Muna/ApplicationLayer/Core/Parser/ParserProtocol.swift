//
//  Parser.swift
//  Muna
//
//  Created by Egor Petrov on 05.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

protocol ParserProtocol {
    var pattern: String { get }

    func parse(fromText text: String, refDate: Date, into items: [ParsedResult]) -> [ParsedResult]

    func extract(fromParsedItem parsedItem: ParsedItem, toParsedResult results: [ParsedResult]) -> [ParsedResult]
}