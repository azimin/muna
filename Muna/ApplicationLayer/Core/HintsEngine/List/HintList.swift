//
//  HintList.swift
//  Muna
//
//  Created by Alexander on 8/24/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

enum HintItem: String, CaseIterable {
    case previewImage
    case changeTime
    case fastCreatOfCard
    case checkShortcutsV1
    case copyImage
    case checkShortcutsV2
    case reportIncorrectOption
    case pingIntervalChange
    case timeIdeas

    var hint: Hint {
        switch self {
        case .previewImage:
            return Hint(
                level: .basic,
                id: self.rawValue,
                text: "You can preview big size screenshot of item by pressing spacebar",
                content: .video(name: "onboarding_part_1", aspectRatio: 1.6),
                available: {
                    ServiceLocator.shared.itemsDatabase.fetchItems(filter: .uncompleted).count > 0
                }
            )
        case .changeTime:
            return Hint(
                level: .basic,
                id: self.rawValue,
                text: "You can change time of item by pressig cmd + t",
                content: .shortcut(shortcutItem:
                    .init(
                        key: .t,
                        modifiers: .command
                    )),
                available: {
                    ServiceLocator.shared.itemsDatabase.fetchItems(filter: .uncompleted).count > 0
                }
            )
        default:
            return Hint(
                level: .basic,
                id: self.rawValue,
                text: "Hi",
                content: .none,
                available: { true }
            )
        }
    }
}
