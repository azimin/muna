//
//  PanelItemModelGrouping.swift
//  Muna
//
//  Created by Alexander on 5/5/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class PanelItemModelGrouping {
    enum Groups: String {
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

    private var names: [Int: Groups] = [:]
    private var values: [Int: [PanelItemModel]] = [:]

    init(items: [PanelItemModel]) {
        for item in items.sorted(by: { (first, second) -> Bool in
            first.dueDate.compare(second.dueDate) == .orderedAscending
        }) {
//            if item.dueDate.compare(<#T##other: Date##Date#>)
        }
    }
}
