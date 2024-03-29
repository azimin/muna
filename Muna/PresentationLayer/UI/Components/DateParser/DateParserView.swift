//
//  DateParserView.swift
//  Muna
//
//  Created by Alexander on 5/24/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class DateParserView: View, RemindersOptionsControllerDelegate {
    var mainOption: DateParserItemView?
    var options: [DateParserItemView] = []
    let itemsStackView = NSStackView(
        orientation: .vertical,
        distribution: .fill
    )

    var selectedIndex: Int = 0

    var controller: RemindersOptionsController

    var topSuperview: NSView? {
        var superview = self as NSView?
        while superview?.superview != nil {
            superview = superview?.superview
        }
        return superview
    }

    init(controller: RemindersOptionsController) {
        self.controller = controller
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.addSubview(self.itemsStackView)
        self.itemsStackView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        let option = DateParserItemView(delegate: self)
        self.mainOption = option
        self.mainOption?.infoLabel.text = ""

        self.itemsStackView.addArrangedSubview(option)
        self.itemsStackView.setCustomSpacing(6, after: option)

        option.update(style: .basic)
        self.options.append(option)

        self.controller.delegate = self
    }

    // MARK: - RemindersOptionsControllerDelegate

    func remindersOptionsControllerShowItems(
        _ controller: RemindersOptionsController,
        items: [ReminderItem],
        animated: Bool
    ) {
        self.mainOption = self.options.first
        self.shouldRunCompletion = false

        var subviewIndex: Int
        if let option = self.mainOption,
            let index = self.itemsStackView.arrangedSubviews.firstIndex(of: option)
        {
            subviewIndex = index
        } else {
            appAssertionFailure("No index")
            subviewIndex = 0
        }

        for (index, item) in items.enumerated() where index != 0 {
            subviewIndex += 1
            let option: DateParserItemView
            if self.options.count > index {
                option = self.options[index]
            } else {
                option = DateParserItemView(delegate: self)
            }
            option.update(style: .notSelected, animated: animated)
            option.update(item: item)
            option.isHidden = true
            self.itemsStackView.insertArrangedSubview(option, at: subviewIndex)
            if self.options.count <= index {
                self.options.append(option)
            }
        }

        if items.count == 0 {
            self.mainOption?.update(style: .basic, animated: animated)
            self.mainOption?.update(item: .init(
                value: .noItem,
                title: "No reminder",
                subtitle: "",
                additionalText: ""
            ))
        } else {
            self.mainOption?.update(style: .selected, animated: animated)
            self.mainOption?.update(item: items[0])
        }

        let numberOfItems = max(items.count, 1)

        let animationBlock = {
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

            self.topSuperview?.layoutSubtreeIfNeeded()
        }

        if animated {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.25
                context.allowsImplicitAnimation = true
                animationBlock()
            }, completionHandler: nil)
        } else {
            animationBlock()
        }
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

    func remindersOptionsControllerSelectItemShouldExitEditState(_ controller: RemindersOptionsController, index: Int) -> Bool {
        let option = self.options[index]

        switch controller.item(by: index)?.value {
        case .none, .date:
            break
        case .noItem:
            return false
        case .canNotFind:
            let suggestion: String
            switch controller.item(by: 0)?.value {
            case .none, .noItem, .canNotFind:
                suggestion = ""
            case let .date(date):
                suggestion = date?.toFormat("dd MMM yyyy HH:mm") ?? ""
            }

            ServiceLocator.shared.analytics.logEvent(
                name: "Report missing time",
                properties: [
                    "due_date_string": self.controller.text,
                    "current_date": Date().toFormat("dd MMM yyyy HH:mm"),
                    "suggestion": suggestion,
                ]
            )

            option.mainLabel.text = "Reported"
            option.infoLabel.text = ""
            return false
        }

        option.update(style: .basic, animated: true)

        self.shouldRunCompletion = true

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.25
            context.allowsImplicitAnimation = true

            for optionIndex in 0 ..< self.options.count where optionIndex != index {
                self.options[optionIndex].isHidden = true
            }

            self.mainOption = option
            self.topSuperview?.layoutSubtreeIfNeeded()
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

        return true
    }
}

extension DateParserView: DateParserItemViewDelegate {
    func dateParserItemSelectedState(item: DateParserItemView) {
        if let index = self.options.firstIndex(of: item) {
            self.controller.selectItem(at: index)
        } else {
            appAssertionFailure("Wrong index")
        }
    }

    func dateParserItemHighlitedState(item: DateParserItemView, highlited: Bool) {
        self.options.forEach { $0.itemHighlighted = false }
        item.itemHighlighted = highlited
    }
}
