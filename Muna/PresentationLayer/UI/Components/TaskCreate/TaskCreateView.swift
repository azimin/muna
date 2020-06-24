//
//  TaskCreateView.swift
//  Muna
//
//  Created by Alexander on 5/11/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SwiftDate

protocol TaskCreateViewDelegate: AnyObject {
    func shortcutsButtonTapped()
    func closeScreenshot()
}

class TaskCreateView: PopupView {
    var parsedDates = [DateItem]()
    let presentationDateItemTransformer: DateItemsTransformer

    let doneButton = PopupButton(style: .basic, title: "Done")

    let reminderTextField = TextField(clearable: true)
    let datePrarserView: DateParserView
    let commentTextField = TextField(clearable: false)

    var controller = RemindersOptionsController(
        behaviour: .emptyState
    )

    private let dateProcessingService = DateProcesingService()
    private let savingProcessingService: SavingProcessingService

    weak var delegate: TaskCreateViewDelegate?

    init(savingProcessingService: SavingProcessingService) {
        self.datePrarserView = DateParserView(controller: self.controller)
        self.savingProcessingService = savingProcessingService
        self.presentationDateItemTransformer = DateItemsTransformer(dateItems: [], configurator: BasicDateItemPresentationConfigurator())

        super.init(style: .withShortcutsButton)
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
        self.reminderTextField.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(insets)
            maker.top.equalTo(self.closeButton.snp.bottom).inset(-16)
        }

        self.addSubview(self.datePrarserView)
        self.datePrarserView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(insets)
            maker.top.equalTo(self.reminderTextField.snp.bottom).inset(-6)
        }

        self.addSubview(self.commentTextField)
        self.commentTextField.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(insets)
            maker.top.equalTo(self.datePrarserView.snp.bottom).inset(-6)
        }

        self.reminderTextField.placeholder = "When to remind"
        self.commentTextField.placeholder = "Comment"

        self.reminderTextField.delegate = self

        self.addSubview(self.doneButton)
        self.doneButton.snp.makeConstraints { maker in
            maker.bottom.leading.trailing.equalToSuperview().inset(
                NSEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
            )
            maker.top.equalTo(self.commentTextField.snp.bottom).inset(-32)
        }

        self.doneButton.action = #selector(self.handleDoneButton)
        self.closeButton.action = #selector(self.handleCloseButton)
        self.shortcutsButton.action = #selector(self.handleShortcutsButton)

        self.controller.showItems(items: [], animated: false)
    }

    var downMonitor: Any?

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
                self.reminderTextField.textField.nextKeyView = self.commentTextField.textField
                self.commentTextField.textField.nextKeyView = self.reminderTextField.textField
                return nil
            } else if Shortcuts.create.item.validateWith(event: event) {
                self.createTask()
                return nil
            }

            return event
        })
    }

    override func viewDidUnhide() {
        super.viewDidUnhide()
        self.addMonitor()

        self.window?.initialFirstResponder = self.reminderTextField.textField
        self.reminderTextField.textField.nextKeyView = self.commentTextField.textField
        self.commentTextField.textField.nextKeyView = self.reminderTextField.textField
    }

    override func viewDidHide() {
        super.viewDidHide()
        self.removeMonitor()

        self.window?.initialFirstResponder = nil
        self.reminderTextField.textField.nextKeyView = nil
        self.commentTextField.textField.nextKeyView = nil
    }

    override func viewWillMove(toWindow newWindow: NSWindow?) {
        if newWindow != nil {
            self.addMonitor()
        } else {
            self.removeMonitor()
        }
    }

    func removeMonitor() {
        if let monitor = self.downMonitor {
            NSEvent.removeMonitor(monitor)
        }
        self.downMonitor = nil
    }

    func clear() {
        self.reminderTextField.clear()
        self.commentTextField.clear()
    }

    // MARK: - Saving

    @objc
    private func handleCloseButton() {
        self.delegate?.closeScreenshot()
    }

    @objc
    private func handleDoneButton() {
        self.createTask()
    }

    func createTask() {
        defer {
            self.delegate?.closeScreenshot()
        }

        var itemToSave = SavingProcessingService.ItemToSave()

        if self.controller.isEmpty == false {
            guard let item = self.controller.item(by: self.controller.selectedIndex) else {
                assertionFailure("No item for index")
                return
            }

            if let date = item.date {
                itemToSave.dueDateString = self.reminderTextField.textField.stringValue
                itemToSave.date = date
            }
        }

        itemToSave.comment = self.commentTextField.textField.stringValue

        self.savingProcessingService.save(withItem: itemToSave)
    }

    @objc
    private func handleShortcutsButton() {
        self.delegate?.shortcutsButtonTapped()
    }
}

extension TaskCreateView: TextFieldDelegate {
    func textFieldTextDidChange(textField: TextField, text: String) {
        let offset = TimeZone.current.secondsFromGMT()

        self.parsedDates = self.dateProcessingService.getDate(from: text, date: Date() + offset.seconds)
        self.presentationDateItemTransformer.setDateItems(self.parsedDates)

        let items = self.presentationDateItemTransformer.dates.compactMap { result -> ReminderItem? in
            ReminderItem(transformedDate: result)
        }

        self.controller.showItems(items: items, animated: true)
    }
}
