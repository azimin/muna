//
//  Parser.swift
//  Muna
//
//  Created by Egor Petrov on 05.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

protocol Parser {

    var pattern: String { get }

    func parse(fromText text: String, refDate: Date) -> ParsedResult?
}
