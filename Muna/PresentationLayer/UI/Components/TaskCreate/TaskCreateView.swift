//
//  TaskCreateView.swift
//  Muna
//
//  Created by Alexander on 5/11/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class TaskCreateView: View {
    let vialPlate = NSVisualEffectView()
    let vialPlateOverlay = View()

    let closeButton = Button()
        .withImageName("icon_close")

    let firstOption = TaskReminderItemView()
    let secondOption = TaskReminderItemView()
    let thirdOption = TaskReminderItemView()

    lazy var options: [TaskReminderItemView] = [
        self.firstOption,
        self.secondOption,
        self.thirdOption,
    ]

    let contentStackView = NSStackView()
    let doneButton = TaskDoneButton()

    var selectedIndex: Int = 0

    override init(frame frameRect: NSRect) {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.backgroundColor = NSColor.clear
        self.snp.makeConstraints { maker in
            maker.width.equalTo(220)
        }
        self.layer?.cornerRadius = 12
        self.layer?.masksToBounds = true

        self.addSubview(self.vialPlate)
        self.vialPlate.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        self.vialPlate.wantsLayer = true
        self.vialPlate.blendingMode = .behindWindow
        self.vialPlate.material = .dark
        self.vialPlate.state = .active
        self.vialPlate.layer?.cornerRadius = 12

        self.addSubview(self.vialPlateOverlay)
        self.vialPlateOverlay.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        self.vialPlateOverlay.layer?.cornerRadius = 12
        self.vialPlateOverlay.layer?.borderWidth = 1
        self.vialPlateOverlay.layer?.borderColor = CGColor.color(.separator)
        self.vialPlateOverlay.backgroundColor = NSColor.color(.black).withAlphaComponent(0.4)

        self.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints { maker in
            maker.top.trailing.equalToSuperview().inset(NSEdgeInsets(
                top: 16,
                left: 0,
                bottom: 0,
                right: 12
            ))
            maker.size.equalTo(CGSize(width: 16, height: 16))
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

        let reminderTextField = TextField()
        reminderTextField.placeholder = "When to remind"

        let commentTextField = TextField()
        commentTextField.placeholder = "Comment"

        self.contentStackView.addArrangedSubview(reminderTextField)
        self.contentStackView.setCustomSpacing(6, after: reminderTextField)
        self.contentStackView.addArrangedSubview(self.firstOption)
        self.contentStackView.setCustomSpacing(2, after: self.firstOption)
        self.contentStackView.addArrangedSubview(self.secondOption)
        self.contentStackView.setCustomSpacing(2, after: self.secondOption)
        self.contentStackView.addArrangedSubview(self.thirdOption)
        self.contentStackView.setCustomSpacing(6, after: self.thirdOption)
        self.contentStackView.addArrangedSubview(commentTextField)

        for view in [self.firstOption, self.secondOption, self.thirdOption] {
            view.snp.makeConstraints { maker in
                maker.width.equalToSuperview()
            }
        }
        self.firstOption.update(style: .selected)
        self.secondOption.update(style: .notSelected)
        self.thirdOption.update(style: .notSelected)

        self.addSubview(self.doneButton)
        self.doneButton.snp.makeConstraints { maker in
            maker.bottom.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.contentStackView.snp.bottom).inset(-32)
        }

        self.addMonitor()
    }

    var downMonitor: Any?

    func addMonitor() {
        self.downMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: { (event) -> NSEvent? in

            if event.keyCode == Key.upArrow.carbonKeyCode {
                self.selectPreveous()
                return nil
            } else if event.keyCode == Key.downArrow.carbonKeyCode {
                self.selectNext()
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
}
