//
//  DateItemController.swift
//  Muna
//
//  Created by Alexander on 5/18/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation
import SwiftDate

struct TransformedDate {
    let date: Date
    let offset: DateOffset?
}

class DateItemsTransformer {
    private var dateItems: [DateItem]
    private let configurator: DateItemPresentationConfiguratorProtocol

    private(set) var dates: [TransformedDate] = []

    init(
        dateItems: [DateItem],
        configurator: DateItemPresentationConfiguratorProtocol
    ) {
        if dateItems.count > 4 {
            self.dateItems = Array(dateItems[0 ..< 4])
        } else {
            self.dateItems = dateItems
        }
        self.configurator = configurator

        self.update()
    }

    func setDateItems(_ dateItems: [DateItem]) {
        self.dateItems = dateItems
        self.update()
    }

    func update() {
        self.dates = []

        let preferedItemsCount: Int

        if self.dateItems.count <= 1 {
            preferedItemsCount = 3
        } else if self.dateItems.count == 2 {
            preferedItemsCount = 2
        } else {
            preferedItemsCount = 1
        }

        for item in self.dateItems {
            let times = self.configurator.transform(
                timeType: item.timeType,
                preferedAmount: preferedItemsCount
            )
            for time in times {
                let date = time.apply(to: item.day)
                let transformedDate = TransformedDate(date: date, offset: item.offset)
                if date.isInFuture {
                    self.dates.append(transformedDate)
                }
            }
        }
    }
}
