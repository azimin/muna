//
//  ReminderItem.swift
//  Muna
//
//  Created by Alexander on 5/24/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class ReminderItem {
    let date: Date?

    // left side
    let title: String
    let subtitle: String

    // right side
    let additionalText: String

    init(date: Date?, title: String, subtitle: String, additionalText: String) {
        self.date = date
        self.title = title
        self.subtitle = subtitle
        self.additionalText = additionalText
    }
}
