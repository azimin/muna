//
//  TaskChangeTimeView.swift
//  Muna
//
//  Created by Alexander on 5/24/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SwiftDate

class TaskChangeTimeView: PopupView {
    var parsedDates = [DateItem]()
    let presentationDateItemTransformer: DateItemsTransformer

    let doneButton = TaskDoneButton()

    let reminderTextField = TextField(clearable: true)
    let datePrarserView: DateParserView

    var controller = RemindersOptionsController(
        behaviour: .remindSuggestionsState
    )

    private let dateParser = MunaChrono()
    private let itemModel: ItemModel

    init(itemModel: ItemModel) {
        self.datePrarserView = DateParserView(controller: self.controller)
        self.itemModel = itemModel
        self.presentationDateItemTransformer = DateItemsTransformer(dateItems: [], configurator: BasicDateItemPresentationConfigurator())

        super.init(style: .withoutShortcutsButton)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setup(forStyle style: Style) {
        super.setup(forStyle: style)

        self.snp.makeConstraints { maker in
            maker.width.equalTo(300)
        }

        let insets = NSEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)

        self.addSubview(self.reminderTextField)
        self.reminderTextField.delegate = self
        self.reminderTextField.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(insets)
            maker.top.equalTo(self.closeButton.snp.bottom).inset(-16)
        }

        self.addSubview(self.datePrarserView)
        self.datePrarserView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(insets)
            maker.top.equalTo(self.reminderTextField.snp.bottom).inset(-6)
        }

        self.reminderTextField.placeholder = "When to remind"

        self.addSubview(self.doneButton)
        self.doneButton.snp.makeConstraints { maker in
            maker.bottom.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.datePrarserView.snp.bottom).inset(-6)
        }

        self.doneButton.action = #selector(self.handleDoneButton)
        self.closeButton.action = #selector(self.handleCloseButton)

        self.addMonitor()

        self.controller.showItems(items: [], animated: false)
    }

    var downMonitor: Any?

    func removeMonitor() {
        if let monitor = self.downMonitor {
            NSEvent.removeMonitor(monitor)
        }
        self.downMonitor = nil
    }

    func addMonitor() {
        self.removeMonitor()

        self.downMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: { (event) -> NSEvent? in

            if DateParserView.Shortcuts.preveousTime.item.validateWith(event: event) {
                self.controller.hilightPreveousItemsIfNeeded()
                return nil
            } else if DateParserView.Shortcuts.nextTime.item.validateWith(event: event) {
                self.controller.hilightNextItemIfNeeded()
                return nil
            } else if self.reminderTextField.isInFocus, DateParserView.Shortcuts.acceptTime.item.validateWith(event: event) {
                self.controller.selectItemIfNeeded()
                return nil
            } else if Shortcuts.create.item.validateWith(event: event) {
                self.updateWithNewTime()
                return nil
            }

            return event
        })
    }

    override func viewDidUnhide() {
        super.viewDidUnhide()
        self.addMonitor()
    }

    override func viewDidHide() {
        super.viewDidHide()
        self.removeMonitor()
    }

    func clear() {
        self.reminderTextField.clear()
    }

    // MARK: - Saving

    @objc
    private func handleCloseButton() {
        self.slowAlert()
    }

    func slowAlert() {
        // TODO: - Implement logic
    }

    @objc
    private func handleDoneButton() {
        self.updateWithNewTime()
    }

    func updateWithNewTime() {
        defer {
            self.slowAlert()
        }

        guard let item = self.controller.item(by: self.controller.selectedIndex) else {
            assertionFailure("No item for index")
            return
        }

        if let date = item.date {
            self.itemModel.dueDateString = self.reminderTextField.textField.stringValue
            self.itemModel.dueDate = date
            ServiceLocator.shared.itemsDatabase.saveItems()
        }
        // TODO: - Update list
    }
}

extension TaskChangeTimeView: TextFieldDelegate {
    func textFieldTextDidChange(textField: TextField, text: String) {
        let offset = TimeZone.current.secondsFromGMT()

        self.parsedDates = self.dateParser.parseFromString(text, date: Date() + offset.seconds)
        self.presentationDateItemTransformer.setDateItems(self.parsedDates)

        let items = self.presentationDateItemTransformer.dates.compactMap { result -> ReminderItem? in
            let formatter = DateParserFormatter(date: result)

            let item = ReminderItem(
                date: result,
                title: formatter.monthDateWeekday,
                subtitle: formatter.subtitle,
                additionalText: formatter.additionalText
            )
            return item
        }

        self.controller.showItems(items: items, animated: true)
    }
}
