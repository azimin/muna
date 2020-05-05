//
//  PanelItemModelGrouping.swift
//  Muna
//
//  Created by Alexander on 5/5/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation
import SwiftDate

class PanelItemModelGrouping {
    enum Group: String, CaseIterable {
        case passed = "Passed"
        case today = "Today"
        case tomorrow = "Tomorrow"
        case later = "Later"
    }

    var sections: Int {
        return self.values.count
    }

    func numberOfItems(in section: Int) -> Int {
        return self.values[section]?.count ?? 0
    }

    func item(at indexPath: IndexPath) -> PanelItemModel {
        return self.values[indexPath.section]![indexPath.item]
    }

    func group(in section: Int) -> Group {
        return self.names[section]!
    }

    private var names: [Int: Group] = [:]
    private var values: [Int: [PanelItemModel]] = [:]

    init(items: [PanelItemModel]) {
        var result: [Group: [PanelItemModel]] = [:]
        for key in Group.allCases {
            result[key] = []
        }

        for item in items.sorted(by: { (first, second) -> Bool in
            first.dueDate < second.dueDate
        }) {
            if item.dueDate < Date() {
                result[.passed]?.append(item)
            } else if item.dueDate.isToday {
                result[.today]?.append(item)
            } else if item.dueDate.isTomorrow {
                result[.tomorrow]?.append(item)
            } else {
                result[.later]?.append(item)
            }
        }

        var index = 0
        for key in Group.allCases {
            if let count = result[key]?.count, count > 0 {
                names[index] = key
                values[index] = result[key]
            }
            index += 1
        }
    }
}
