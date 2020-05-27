//
//  RemindersOptionsController.swift
//  Muna
//
//  Created by Alexander on 5/13/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation
import SwiftDate

protocol RemindersOptionsControllerDelegate: AnyObject {
    func remindersOptionsControllerShowItems(
        _ controller: RemindersOptionsController,
        items: [ReminderItem],
        animated: Bool
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

    var isEmpty: Bool {
        return self.avialbleItems.isEmpty
    }

    private let behaviour: Behaviour

    init(behaviour: Behaviour) {
        self.behaviour = behaviour
    }

    private var avialbleItems: [ReminderItem] = []

    func showItems(items: [ReminderItem], animated: Bool) {
        self.isEditingState = true

        switch self.behaviour {
        case .emptyState:
            self.avialbleItems = items
        case .remindSuggestionsState:
            if items.isEmpty {
                self.avialbleItems = RemindersOptionsController
                    .predefineSuggestions(date: Date())
            } else {
                self.avialbleItems = items
            }
        }

        self.selectedIndex = 0
        self.delegate?.remindersOptionsControllerShowItems(
            self,
            items: self.avialbleItems,
            animated: animated
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
    static func predefineSuggestions(date: Date) -> [ReminderItem] {
        var values = [
            ReminderItem(
                date: date + 5.minutes,
                title: "In 5 mins",
                subtitle: "",
                additionalText: ""
            ),
            ReminderItem(
                date: date + 30.minutes,
                title: "In 30 mins",
                subtitle: "",
                additionalText: ""
            ),
            ReminderItem(
                date: date + 1.hours,
                title: "In 1 hour",
                subtitle: "",
                additionalText: ""
            ),
        ]

        if let eveningDate = date.dateBySet(hour: 7, min: 0, secs: 0),
            date < eveningDate {
            values.append(
                ReminderItem(
                    date: eveningDate,
                    title: "In the evening",
                    subtitle: "",
                    additionalText: eveningDate.timeSmartString(showMinutes: false)
                )
            )
        }

        let configurator = BasicDateItemPresentationConfigurator()
        let tomorrow = (date + 1.days)
        if let time = configurator.transform(timeType: .allDay, preferedAmount: 1).first {
            let tomorrowDate = time.apply(to: .init(date: tomorrow))
            let representable = tomorrowDate.representableDate()

            let month = representable.monthName(.short)
            let day = representable.ordinalDay

            values.append(
                ReminderItem(
                    date: tomorrowDate,
                    title: "Tomorrow (\(day) \(month))",
                    subtitle: "",
                    additionalText: representable.timeSmartString(showMinutes: false)
                )
            )
        }

        var weekends = date
        repeat {
            let newDate = weekends + 1.days
            weekends = newDate
        } while weekends.isInWeekend == false

        if let time = configurator.transform(timeType: .allDay, preferedAmount: 1).first {
            let weekendsDate = time.apply(to: .init(date: weekends))
            let representable = weekendsDate.representableDate()

            let title = DateParserFormatter(date: weekendsDate).weekdayDayMonth
            values.append(
                ReminderItem(
                    date: weekendsDate,
                    title: title,
                    subtitle: "",
                    additionalText: representable.timeSmartString(showMinutes: false)
                )
            )
        }

        return values
    }
}
