//
//  ENMonthOffsetParser.swift
//  Muna
//
//  Created by Egor Petrov on 01.06.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class ENMonthOffsetParser: Parser {
    override var pattern: String {
        return "\\b(?:(in|next|past|this)\\s*)"
            + "(\\d{1,})?"
            + "(\\s*(months|month?))\\b"
    }

    let prefixGroup = 1
    let numberOfMonthsGroup = 2
    let monthGroup = 3
}
