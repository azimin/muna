//
//  WindowType.swift
//  Muna
//
//  Created by Alexander on 8/5/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

enum WindowType: Equatable, Hashable {
    case panel(selectedItem: ItemModel?)
    case screenshot
    case fullScreenshot
    case debug
    case settings
    case onboarding
    case remindLater(item: ItemModel)

    var analytics: String {
        switch self {
        case let .panel(item):
            return item == nil ? "panel" : "panel_selected_item"
        case .screenshot:
            return "screenshot"
        case .fullScreenshot:
            return "fullScreenshot"
        case .debug:
            return "debug"
        case .settings:
            return "settings"
        case .onboarding:
            return "onboarding"
        case .remindLater:
            return "remindLater"
        }
    }

    var rawValue: String {
        switch self {
        case .panel:
            return "panel"
        case .screenshot:
            return "screenshot"
        case .fullScreenshot:
            return "fullScreenshot"
        case .debug:
            return "debug"
        case .settings:
            return "settings"
        case .onboarding:
            return "onboarding"
        case let .remindLater(item):
            return "remindLater_\(item.id)"
        }
    }

    static func == (lhs: WindowType, rhs: WindowType) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }

    func hash(into hasher: inout Hasher) {
        self.rawValue.hash(into: &hasher)
    }
}
