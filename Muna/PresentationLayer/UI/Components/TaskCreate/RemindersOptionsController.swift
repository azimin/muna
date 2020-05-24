//
//  RemindersOptionsController.swift
//  Muna
//
//  Created by Alexander on 5/13/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

protocol RemindersOptionsControllerDelegate: AnyObject {
    func remindersOptionsControllerShowItems(
        _ controller: RemindersOptionsController,
        items: [ReminderItem]
    )

    func remindersOptionsControllerHighliteItem(
        _ controller: RemindersOptionsController,
        index: Int
    )

    func remindersOptionsControllerSelectItem(
        _ controller: RemindersOptionsController,
        index: Int
    )
}

class RemindersOptionsController {
    enum Behaviour {
        case emptyState
        case remindSuggestionsState
    }

    weak var delegate: RemindersOptionsControllerDelegate?

    private var isEditingState: Bool = false
    private(set) var selectedIndex = 0

    private let behaviour: Behaviour

    init(behaviour: Behaviour) {
        self.behaviour = behaviour
    }

    private var avialbleItems: [ReminderItem] = []

    func showItems(items: [ReminderItem]) {
        self.isEditingState = true

        switch self.behaviour {
        case .emptyState:
            self.avialbleItems = items
        case .remindSuggestionsState:
            if items.isEmpty {
            } else {
                self.avialbleItems = items
            }
        }

        self.selectedIndex = 0
        self.delegate?.remindersOptionsControllerShowItems(
            self,
            items: self.avialbleItems
        )
    }

    func hilightNextItemIfNeeded() {
        guard self.isEditingState else {
            return
        }

        let newIndex = self.selectedIndex + 1
        if newIndex < self.avialbleItems.count {
            self.selectedIndex = newIndex
            self.delegate?.remindersOptionsControllerHighliteItem(
                self,
                index: newIndex
            )
        }
    }

    func item(by index: Int) -> ReminderItem? {
        guard self.avialbleItems.count > index else {
            return nil
        }
        return self.avialbleItems[index]
    }

    func hilightPreveousItemsIfNeeded() {
        guard self.isEditingState else {
            return
        }

        let newIndex = self.selectedIndex - 1
        if newIndex >= 0, newIndex < self.avialbleItems.count {
            self.selectedIndex = newIndex
            self.delegate?.remindersOptionsControllerHighliteItem(
                self,
                index: newIndex
            )
        }
    }

    func selectItemIfNeeded() {
        guard self.isEditingState else {
            return
        }

        self.isEditingState = false
        self.delegate?.remindersOptionsControllerSelectItem(
            self,
            index: self.selectedIndex
        )
    }
}

private extension RemindersOptionsController {
    static func prefefineSuggestions(date: Date) -> [ReminderItem] {
        return []
    }
}
