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

        let option = DateParserItemView()
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
        items: [ReminderItem]
    ) {
        self.mainOption = self.options.first
        self.shouldRunCompletion = false

        var subviewIndex: Int
        if let option = self.mainOption,
            let index = self.itemsStackView.arrangedSubviews.firstIndex(of: option) {
            subviewIndex = index
        } else {
            assertionFailure("No index")
            subviewIndex = 0
        }

        for (index, item) in items.enumerated() where index != 0 {
            subviewIndex += 1
            let option: DateParserItemView
            if self.options.count > index {
                option = self.options[index]
            } else {
                option = DateParserItemView()
            }
            option.update(style: .notSelected, animated: true)
            option.update(item: item)
            option.isHidden = true
            self.itemsStackView.insertArrangedSubview(option, at: subviewIndex)
            if self.options.count <= index {
                self.options.append(option)
            }
        }

        if items.count == 0 {
            self.mainOption?.update(style: .basic, animated: true)
            self.mainOption?.update(item: .init(
                date: nil,
                title: "No reminder",
                subtitle: "",
                additionalText: ""
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

            self.superview?.layoutSubtreeIfNeeded()
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
            self.superview?.layoutSubtreeIfNeeded()
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
}
