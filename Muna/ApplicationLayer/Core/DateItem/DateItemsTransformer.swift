//
//  DateItemController.swift
//  Muna
//
//  Created by Alexander on 5/18/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class DateItemsTransformer {
    private let dateItems: [DateItem]
    private let configurator: DateItemPresentationConfiguratorProtocol

    private(set) var dates: [Date] = []

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

        self.setup()
    }

    func setup() {
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
                self.dates.append(date)
            }
        }
    }
}