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
        items: [RemindersOptionsController.ReminderItem]
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
    weak var delegate: RemindersOptionsControllerDelegate?

    private var isEditingState: Bool = false
    private var selectedIndex = 0

    class ReminderItem {
        // left side
        let title: String
        let subtitle: String

        // right side
        let additionalText: String

        init(title: String, subtitle: String, additionalText: String) {
            self.title = title
            self.subtitle = subtitle
            self.additionalText = additionalText
        }
    }

    private var avialbleItems: [ReminderItem] = []

    func showItems(items: [ReminderItem]) {
        self.isEditingState = true
        self.avialbleItems = items
        self.selectedIndex = 0

        self.delegate?.remindersOptionsControllerShowItems(
            self,
            items: items
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
        guard !self.avialbleItems.isEmpty else {
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
