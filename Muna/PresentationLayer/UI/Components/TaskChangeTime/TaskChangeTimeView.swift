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

    let removeTimeButton = PopupButton(style: .distructive, title: "Remove time")
    let doneButton = PopupButton(style: .basic, title: "Done")

    let reminderTextField = TextField(clearable: true)
    let datePrarserView: DateParserView

    var controller = RemindersOptionsController(
        behaviour: .remindSuggestionsState
    )

    private let dateProcessingService = DateProcesingService()
    private let itemModel: ItemModel

    private var closeHandler: CloseHandler?

    init(itemModel: ItemModel, closeHandler: CloseHandler?) {
        self.closeHandler = closeHandler
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

        self.addSubview(self.removeTimeButton)
        self.removeTimeButton.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(
                NSEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
            )
            maker.top.equalTo(self.datePrarserView.snp.bottom).inset(-12)
        }

        self.addSubview(self.doneButton)
        self.doneButton.snp.makeConstraints { maker in
            maker.bottom.leading.trailing.equalToSuperview().inset(
                NSEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
            )
            maker.top.equalTo(self.removeTimeButton.snp.bottom).inset(-12)
        }

        self.removeTimeButton.target = self
        self.removeTimeButton.action = #selector(self.handleRemoveTimeButton)

        self.doneButton.target = self
        self.doneButton.action = #selector(self.handleDoneButton)

        self.closeButton.target = self
        self.closeButton.action = #selector(self.handleCloseButton)

        self.addMonitor()

        self.controller.showItems(text: "", items: [], animated: false)
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

        self.downMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: { [weak self] (event) -> NSEvent? in
            guard let self = self else { return event }

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
            } else if Shortcuts.close.item.validateWith(event: event) {
                self.closeAlert()
                return nil
            }

            return event
        })
    }

    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        if event.keyCode == Key.escape.carbonKeyCode {
            self.closeAlert()
            return true
        }

        return super.performKeyEquivalent(with: event)
    }

    override func viewDidUnhide() {
        super.viewDidUnhide()
        self.addMonitor()
    }

    override func viewDidHide() {
        super.viewDidHide()
        self.removeMonitor()
    }

    override func viewWillMove(toWindow newWindow: NSWindow?) {
        if newWindow != nil {
            self.addMonitor()
        } else {
            self.removeMonitor()
        }
    }

    override func viewDidMoveToWindow() {
        OperationQueue.main.addOperation {
            self.window?.makeFirstResponder(self.reminderTextField.textField)
        }
    }

    func clear() {
        self.reminderTextField.clear()
    }

    // MARK: - Saving

    @objc
    private func handleRemoveTimeButton() {
        defer {
            self.closeAlert()
        }

        self.itemModel.dueDateString = nil
        self.itemModel.dueDate = nil

        ServiceLocator.shared.notifications.removeNotification(item: self.itemModel)
        ServiceLocator.shared.itemsDatabase.saveItems()
    }

    @objc
    private func handleCloseButton() {
        self.closeAlert()
    }

    func closeAlert() {
        guard let closeAction = self.closeHandler?.close else {
            appAssertionFailure("No close handler")
            return
        }

        closeAction()
    }

    @objc
    private func handleDoneButton() {
        self.updateWithNewTime()
    }

    func updateWithNewTime() {
        defer {
            self.closeAlert()
        }

        guard let item = self.controller.item(by: self.controller.selectedIndex) else {
            appAssertionFailure("No item for index")
            return
        }

        switch item.value {
        case .canNotFind, .noItem:
            break
        case let .date(date):
            if let date = date {
                self.itemModel.dueDateString = self.reminderTextField.textField.stringValue
                self.itemModel.dueDate = date
                let value = self.itemModel.numberOfTimeChanges ?? 0
                self.itemModel.numberOfTimeChanges = value + 1

                ServiceLocator.shared.notifications.removeNotification(item: self.itemModel)
                ServiceLocator.shared.notifications.sheduleNotification(item: self.itemModel)
                ServiceLocator.shared.itemsDatabase.saveItems()
            }
        }
    }
}

extension TaskChangeTimeView: TextFieldDelegate {
    func textFieldTextDidChange(textField: TextField, text: String) {
        let offset = TimeZone.current.secondsFromGMT()

        self.parsedDates = self.dateProcessingService.getDate(from: text, date: Date() + offset.seconds)
        self.presentationDateItemTransformer.setDateItems(self.parsedDates)

        let items = self.presentationDateItemTransformer.dates.compactMap { result -> ReminderItem? in
            ReminderItem(transformedDate: result)
        }

        self.controller.showItems(
            text: text,
            items: items,
            animated: true
        )
    }
}
