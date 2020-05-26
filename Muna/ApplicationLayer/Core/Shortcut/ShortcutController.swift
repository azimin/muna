//
//  ShortcutController.swift
//  Muna
//
//  Created by Alexander on 5/14/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

protocol ShortcutsControllerProtocol {
    func start()
    func stop()

    func performKeyEquivalent(with event: NSEvent) -> Bool
    func insertText(_ insertString: Any) -> Bool
}

class ShortcutsController: ShortcutsControllerProtocol {
    private var shouldPerformKeys: Bool = false

    private let shortcutActions: [ShortcutAction]

    init(shortcutActions: [ShortcutAction]) {
        self.shortcutActions = shortcutActions
    }

    private var monitor: Any?

    func start() {
        self.stop()

        self.shouldPerformKeys = true
        self.monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: { [weak self] (event) -> NSEvent? in
            guard let self = self else { return event }

            var performedAnotherEvent = false

            for shortcutAction in self.shortcutActions {
                if shortcutAction.item.validateWith(event: event) {
                    shortcutAction.action?()
                    performedAnotherEvent = true
                }
            }

            return performedAnotherEvent ? nil : event
        })
    }

    deinit {
        self.stop()
    }

    func stop() {
        self.shouldPerformKeys = false

        if let monitor = self.monitor {
            NSEvent.removeMonitor(monitor)
            self.monitor = nil
        }
    }

    func performKeyEquivalent(with event: NSEvent) -> Bool {
        guard self.shouldPerformKeys else {
            return true
        }

        for shortcutAction in self.shortcutActions {
            if shortcutAction.item.validateWith(event: event) {
                shortcutAction.action?()
            }
        }

        return true
    }

    func insertText(_ insertString: Any) -> Bool {
        guard let string = insertString as? String else {
            return false
        }

        // space
        if string == " " {
            if let action = shortcutActions.first(where: { $0.item.key == .space && $0.item.modifierFlags.isEmpty }) {
                action.action?()
                return true
            }
        }

        return false
    }
}
