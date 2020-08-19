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

    func remindersOptionsControllerSelectItemShouldExitEditState(
        _ controller: RemindersOptionsController,
        index: Int
    ) -> Bool
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
    private(set) var text: String = ""

    func showItems(text: String, items: [ReminderItem], animated: Bool) {
        self.isEditingState = true
        self.text = text

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

        if text.count >= 3 {
            self.avialbleItems.append(
                .init(value: .canNotFind,
                      title: "Can't find correct option",
                      subtitle: "",
                      additionalText: "Report")
            )
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

    func selectItem(at index: Int) {
        guard self.isEditingState else {
            return
        }

        guard self.avialbleItems.count > index else {
            appAssertionFailure("Wrong index")
            return
        }

        let shouldExitEditState = self.delegate?.remindersOptionsControllerSelectItemShouldExitEditState(
            self,
            index: self.selectedIndex
        ) ?? false

        if shouldExitEditState {
            self.isEditingState = false
            self.selectedIndex = index
        }
    }

    func selectItemIfNeeded() {
        guard self.isEditingState else {
            return
        }

        let shouldExitEditState = self.delegate?.remindersOptionsControllerSelectItemShouldExitEditState(
            self,
            index: self.selectedIndex
        ) ?? false

        if shouldExitEditState {
            self.isEditingState = false
        }
    }
}

private extension RemindersOptionsController {
    static func predefineSuggestions(date: Date) -> [ReminderItem] {
        var values = [
            ReminderItem(
                value: .date(date: date + 5.minutes),
                title: "In 5 mins",
                subtitle: "",
                additionalText: ""
            ),
            ReminderItem(
                value: .date(date: date + 30.minutes),
                title: "In 30 mins",
                subtitle: "",
                additionalText: ""
            ),
            ReminderItem(
                value: .date(date: date + 1.hours),
                title: "In 1 hour",
                subtitle: "",
                additionalText: ""
            ),
        ]

        if let eveningDate = date.dateBySet(hour: 7, min: 0, secs: 0),
            date < eveningDate {
            values.append(
                ReminderItem(
                    value: .date(date: eveningDate),
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
                    value: .date(date: tomorrowDate),
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
                    value: .date(date: weekendsDate),
                    title: title,
                    subtitle: "",
                    additionalText: representable.timeSmartString(showMinutes: false)
                )
            )
        }

        return values
    }
}
