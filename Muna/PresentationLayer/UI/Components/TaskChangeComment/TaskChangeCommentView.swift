//
//  TaskChangeCommentView.swift
//  Muna
//
//  Created by Alexander on 2/18/21.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Foundation

class TaskChangeCommentView: PopupView {
    let doneButton = PopupButton(style: .basic, title: "Finish Editing (⌘↵)")
    let commentTextField = TextField(clearable: true, numberOfLines: 10)

    private let itemModel: ItemModel
    private var closeHandler: CloseHandler?

    init(itemModel: ItemModel, closeHandler: CloseHandler?) {
        self.closeHandler = closeHandler
        self.itemModel = itemModel

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

        self.addSubview(self.commentTextField)
        self.commentTextField.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(insets)
            maker.top.equalTo(self.closeButton.snp.bottom).inset(-16)
        }

        self.commentTextField.placeholder = "Comment"

        self.addSubview(self.doneButton)
        self.doneButton.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview().inset(
                NSEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
            )
            make.top.equalTo(self.commentTextField.snp.bottom).inset(-12)
        }

        self.doneButton.target = self
        self.doneButton.action = #selector(self.handleDoneButton)

        self.closeButton.target = self
        self.closeButton.action = #selector(self.handleCloseButton)

        self.addMonitor()
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

            if Shortcuts.create.item.validateWith(event: event) {
                self.updateWithNewComment()
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
            self.window?.makeFirstResponder(self.commentTextField.textField)
        }
    }

    func clear() {
        self.commentTextField.clear()
    }

    // MARK: - Saving

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
        self.updateWithNewComment()
    }

    func updateWithNewComment() {
        defer {
            self.closeAlert()
        }

        self.itemModel.comment = self.commentTextField.textField.stringValue
        ServiceLocator.shared.itemsDatabase.saveItems()
    }
}

extension TaskChangeCommentView {
    enum Shortcuts: ViewShortcutProtocol {
        case create
        case close

        var item: ShortcutItem {
            switch self {
            case .create:
                return ShortcutItem(key: .return, modifiers: [.shift])
            case .close:
                return ShortcutItem(key: .w, modifiers: [.command])
            }
        }
    }
}
