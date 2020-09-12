//
//  SettingsViewController.swift
//  Muna
//
//  Created by Alexander on 5/14/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class SettingsViewController: NSViewController, NSToolbarDelegate {
    enum ToolbarItem: String, CaseIterable {
        case general = "General"
        case shortcuts = "Shortcuts"
        case habits = "Habits"
        case about = "About"

        var identifier: NSToolbarItem.Identifier {
            return NSToolbarItem.Identifier(self.rawValue)
        }

        var image: NSImage? {
            let themeSufix = Theme.current == .dark ? "dark" : "light"
            switch self {
            case .general:
                return NSImage(named: "setting_toolbar_general_\(themeSufix)")
            case .shortcuts:
                return NSImage(named: "setting_toolbar_shortcuts_\(themeSufix)")
            case .about:
                return NSImage(named: "setting_toolbar_about")
            case .habits:
                return NSImage(named: "setting_toolbar_habits_\(themeSufix)")
            }
        }
    }

    private let generalViewController = GeneralSettingsViewController()
    private let shortcutsViewController = ShortcutsSettingsViewController()
    private let aboutViewController = AboutSettingsViewController()
    private let habitsViewcontroller = HabitsSettingsViewController()

    private var currentItem: ToolbarItem?
    let toolbar = NSToolbar(identifier: NSToolbar.Identifier("settings"))

    var window: NSWindow {
        return self.view.window!
    }

    override func loadView() {
        self.view = SettingsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    var isFirstAppear = true

    override func viewWillLayout() {
        super.viewWillLayout()

        for (key, value) in self.toolbarItems {
            value.image = key.image
        }
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        guard self.isFirstAppear else {
            return
        }
        self.isFirstAppear = false

        self.toolbar.delegate = self
        self.toolbar.allowsUserCustomization = false
        self.view.window?.toolbar = self.toolbar
        self.setView(for: .general, animate: false)

        self.window.makeKeyAndOrderFront(nil)
        self.window.center()
    }

    // MARK: - Control

    @objc
    func switchToolbarItem(_ toolbarItem: NSToolbarItem) {
        guard let item = ToolbarItem(rawValue: toolbarItem.itemIdentifier.rawValue) else {
            appAssertionFailure("No supported item")
            return
        }

        self.setView(for: item, animate: true)
    }

    func setView(for item: ToolbarItem, animate: Bool) {
        if let oldItem = self.currentItem {
            if oldItem == item {
                return
            }

            let oldViewController = self.viewController(for: oldItem)
            oldViewController.view.removeFromSuperview()
        }

        self.currentItem = item

        let newViewController = self.viewController(for: item)
        let newFrame = self.frameFromView(newWiew: newViewController.view)

        self.toolbar.selectedItemIdentifier = self.currentItem?.identifier
        self.window.title = newViewController.title ?? ""

        let titlebarHeight = self.window.titlebarHeight

        self.window.setFrame(newFrame, display: true, animate: animate)
        self.window.contentView?.addSubview(newViewController.view)
        newViewController.view.frame = CGRect(
            x: 0,
            y: 0,
            width: newFrame.width,
            height: newFrame.height - titlebarHeight
        )
    }

    // MARK: - Helpers

    private func viewController(for item: ToolbarItem) -> NSViewController {
        switch item {
        case .general:
            return self.generalViewController
        case .shortcuts:
            return self.shortcutsViewController
        case .about:
            return self.aboutViewController
        case .habits:
            return self.habitsViewcontroller
        }
    }

    private func frameFromView(newWiew: NSView) -> NSRect {
        var oldFrame = self.window.frame
        var newSize = newWiew.fittingSize
        newSize.height += self.window.titlebarHeight

        oldFrame.origin = NSPoint(
            x: oldFrame.origin.x - (newSize.width - oldFrame.width),
            y: oldFrame.origin.y - (newSize.height - oldFrame.height)
        )
        oldFrame.size = newSize

        return oldFrame
    }

    // MARK: - Toolbar

    var toolbarItems: [ToolbarItem: NSToolbarItem] = [:]
    var itemsIdentifiers: [NSToolbarItem.Identifier] = {
        var values = ToolbarItem.allCases.map { $0.identifier }
        values.insert(.flexibleSpace, at: values.count - 1)
        return values
    }()

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return self.itemsIdentifiers
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return self.itemsIdentifiers
    }

    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return self.itemsIdentifiers
    }

    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        guard let item = ToolbarItem(rawValue: itemIdentifier.rawValue) else {
            appAssertionFailure("Not correct identifier")
            return nil
        }

        let toolbarItem = NSToolbarItem(itemIdentifier: item.identifier)
        toolbarItem.label = item.rawValue
        toolbarItem.image = item.image
        toolbarItem.action = #selector(self.switchToolbarItem(_:))

        self.toolbarItems[item] = toolbarItem

        return toolbarItem
    }
}

extension NSWindow {
    var titlebarHeight: CGFloat {
        let contentHeight = contentRect(forFrameRect: frame).height
        return frame.height - contentHeight
    }
}
