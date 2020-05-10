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
        case new = "New"
        case passed = "Passed"
        case today = "Today"
        case tomorrow = "Tomorrow"
        case later = "Later"
        case noDate = "No date"
        case completed = "Completed"
    }

    var totalNumberOfItems: Int {
        return self.values.reduce(0) { $0 + $1.value.count }
    }

    var sections: Int {
        return self.values.count
    }

    func numberOfItems(in section: Int) -> Int {
        return self.values[section]?.count ?? 0
    }

    func item(at indexPath: IndexPath) -> ItemModel {
        return self.values[indexPath.section]![indexPath.item]
    }

    func group(in section: Int) -> Group {
        return self.names[section]!
    }

    private var names: [Int: Group] = [:]
    private var values: [Int: [ItemModel]] = [:]

    // swiftlint:disable cyclomatic_complexity
    init(items: [ItemModel]) {
        var result: [Group: [ItemModel]] = [:]
        for key in Group.allCases {
            result[key] = []
        }

        for item in items.sorted(by: { (first, second) -> Bool in
            if first.dueDate != nil, second.dueDate == nil {
                return true
            }
            if first.dueDate == nil, second.dueDate != nil {
                return false
            }
            if let firstDueDate = first.dueDate, let secondDueDate = second.dueDate {
                return firstDueDate < secondDueDate
            }
            return first.creationDate < second.creationDate
        }) {
            if item.isNew {
                result[.new]?.append(item)
            } else if item.isComplited {
                result[.completed]?.append(item)
            } else if let dueDate = item.dueDate {
                if dueDate < Date() {
                    result[.passed]?.append(item)
                } else if dueDate.isToday {
                    result[.today]?.append(item)
                } else if dueDate.isTomorrow {
                    result[.tomorrow]?.append(item)
                } else {
                    result[.later]?.append(item)
                }
            } else {
                result[.noDate]?.append(item)
            }
        }

        var index = 0
        for key in Group.allCases {
            if let count = result[key]?.count, count > 0 {
                self.names[index] = key
                self.values[index] = result[key]
                index += 1
            }
        }
    }
}
