//
//  TaskCreateView.swift
//  Muna
//
//  Created by Alexander on 5/11/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SwiftDate

class TaskCreateView: PopupView, RemindersOptionsControllerDelegate {
    var mainOption: TaskReminderItemView?

    var parsedDates = [ParsedResult]()

    var options: [TaskReminderItemView] = []

    let contentStackView = NSStackView()
    let doneButton = TaskDoneButton()

    let reminderTextField = TextField(clearable: true)
    let commentTextField = TextField(clearable: false)

    var selectedIndex: Int = 0

    var controller = RemindersOptionsController()

    private let dateParser = MunaChrono()
    private let savingProcessingService: SavingProcessingService

    init(savingProcessingService: SavingProcessingService) {
        self.savingProcessingService = savingProcessingService

        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setup() {
        super.setup()

        self.snp.makeConstraints { maker in
            maker.width.equalTo(220)
        }

        self.addSubview(self.contentStackView)
        self.contentStackView.distribution = .fill
        self.contentStackView.orientation = .vertical
        self.contentStackView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(NSEdgeInsets(
                top: 16,
                left: 12,
                bottom: 16,
                right: 12
            ))
            maker.top.equalTo(self.closeButton.snp.bottom).inset(-16)
        }

        self.reminderTextField.placeholder = "When to remind"

        self.commentTextField.placeholder = "Comment"

        let option = TaskReminderItemView()
        self.mainOption = option
        self.mainOption?.infoLabel.text = ""

        self.contentStackView.addArrangedSubview(self.reminderTextField)
        self.contentStackView.setCustomSpacing(6, after: self.reminderTextField)
        self.contentStackView.addArrangedSubview(option)
        self.contentStackView.setCustomSpacing(6, after: option)
        self.contentStackView.addArrangedSubview(self.commentTextField)

        self.reminderTextField.delegate = self

        option.update(style: .basic)
        self.options.append(option)

        self.addSubview(self.doneButton)
        self.doneButton.snp.makeConstraints { maker in
            maker.bottom.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.contentStackView.snp.bottom).inset(-32)
        }

        self.doneButton.action = #selector(self.handleDoneButton)
        self.closeButton.action = #selector(self.handleCloseButton)

        self.addMonitor()

        self.controller.delegate = self
    }

    var downMonitor: Any?

    func addMonitor() {
        self.downMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: { (event) -> NSEvent? in

            if Shortcuts.preveousTime.item.validateWith(event: event) {
                self.controller.hilightPreveousItemsIfNeeded()
                return nil
            } else if Shortcuts.nextTime.item.validateWith(event: event) {
                self.controller.hilightNextItemIfNeeded()
                return nil
            } else if self.reminderTextField.isInFocus, Shortcuts.acceptTime.item.validateWith(event: event) {
                self.controller.selectItemIfNeeded()
                return nil
            } else if Shortcuts.create.item.validateWith(event: event) {
                self.createTask()
                return nil
            }

            return event
        })
    }

    func selectPreveous() {
        if self.selectedIndex > 0 {
            self.options[self.selectedIndex].update(style: .notSelected)
            self.selectedIndex -= 1
        }
        self.options[self.selectedIndex].update(style: .selected)
    }

    func selectNext() {
        if self.selectedIndex < self.options.count - 1 {
            self.options[self.selectedIndex].update(style: .notSelected)
            self.selectedIndex += 1
        }
        self.options[self.selectedIndex].update(style: .selected)
    }

    // MARK: - RemindersOptionsControllerDelegate

    func remindersOptionsControllerShowItems(
        _ controller: RemindersOptionsController,
        items: [RemindersOptionsController.ReminderItem]
    ) {
        self.mainOption = self.options.first
        self.shouldRunCompletion = false

        var subviewIndex = self.contentStackView.arrangedSubviews.firstIndex(of: self.mainOption!) ?? 0

        for (index, item) in items.enumerated() where index != 0 {
            subviewIndex += 1
            let option: TaskReminderItemView
            if self.options.count > index {
                option = self.options[index]
            } else {
                option = TaskReminderItemView()
            }
            option.update(style: .notSelected, animated: true)
            option.update(item: item)
            option.isHidden = true
            self.contentStackView.insertArrangedSubview(option, at: subviewIndex)
            if self.options.count <= index {
                self.options.append(option)
            }
        }

        if items.count == 0 {
            self.mainOption?.update(style: .basic, animated: true)
            self.mainOption?.update(item: .init(
                title: "No reminder",
                subtitle: ""
            ))
        } else {
            self.mainOption?.update(style: .selected, animated: true)
            self.mainOption?.update(item: items[0])
        }

        let numberOfItems = max(items.count, 1)
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.25
            context.allowsImplicitAnimation = true

            for optionIndex in 0 ..< numberOfItems {
                self.options[optionIndex].isHidden = false
            }
            if numberOfItems < self.options.count {
                var offset = 0
                for itemIndex in numberOfItems ..< self.options.count {
                    self.options[itemIndex - offset].removeFromSuperview()
                    self.options.remove(at: itemIndex - offset)
                    offset += 1
                }
            }

            self.layoutSubtreeIfNeeded()
        }, completionHandler: nil)
    }

    func remindersOptionsControllerHighliteItem(
        _ controller: RemindersOptionsController,
        index: Int
    ) {
        for (optionIndex, option) in self.options.enumerated() {
            option.update(
                style: optionIndex == index ? .selected : .notSelected
            )
        }
    }

    private var shouldRunCompletion = false

    func remindersOptionsControllerSelectItem(
        _ controller: RemindersOptionsController,
        index: Int
    ) {
        let option = self.options[index]
        option.update(style: .basic, animated: true)

        self.shouldRunCompletion = true

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.25
            context.allowsImplicitAnimation = true

            for optionIndex in 0 ..< self.options.count where optionIndex != index {
                self.options[optionIndex].isHidden = true
            }

            self.mainOption = option
            self.layoutSubtreeIfNeeded()
        }, completionHandler: {
            guard self.shouldRunCompletion else {
                return
            }

            var offset = 0
            for optionIndex in 0 ..< self.options.count where optionIndex != index {
                self.options[optionIndex - offset].removeFromSuperview()
                self.options.remove(at: optionIndex - offset)
                offset += 1
            }
        })
    }

    // MARK: - Saving

    @objc
    private func handleCloseButton() {
        // TODO: - Improve
        (NSApplication.shared.delegate as? AppDelegate)?.toggleScreenshotState()
    }

    @objc
    private func handleDoneButton() {
        self.createTask()
    }

    func createTask() {
        guard let reminderItem = self.controller.item(by: self.selectedIndex) else {
            return
        }

        let parsedResult = self.parsedDates[self.selectedIndex]

        let itemToSave = SavingProcessingService.ItemToSave(
            dueDateString: reminderItem.title,
            date: parsedResult.date,
            comment: self.commentTextField.textField.stringValue
        )
        self.savingProcessingService.save(withItem: itemToSave)
        // TODO: - Improve close process
        (NSApplication.shared.delegate as? AppDelegate)?.toggleScreenshotState()
    }
}

extension TaskCreateView: TextFieldDelegate {
    func textFieldTextDidChange(textField: TextField, text: String) {
        self.parsedDates = self.dateParser.parseFromString(text, date: Date())

        var items = self.parsedDates.compactMap { result -> RemindersOptionsController.ReminderItem? in
            guard let offset = result.date.difference(in: .day, from: Date()) else {
                return nil
            }
            let item = RemindersOptionsController.ReminderItem(
                title: "\(result.date.monthName(.short)), \(result.date.ordinalDay) \(result.date.weekdayName(.short))",
                subtitle: "in \(offset) days"
            )
            return item
        }

        if text == "t" {
            items.append(.init(title: "Today", subtitle: "1"))
            items.append(.init(title: "Today", subtitle: "2"))
        }
        if text == "tt" {
            items.append(.init(title: "Yersterday", subtitle: "1"))
        }

        print(items)
        self.controller.showItems(items: items)
    }
}
