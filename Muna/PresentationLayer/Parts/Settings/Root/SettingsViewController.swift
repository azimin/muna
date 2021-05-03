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
        case tips = "Tips"
//        case habits = "Habits"
        case about = "About"

        var identifier: NSToolbarItem.Identifier {
            return NSToolbarItem.Identifier(self.rawValue)
        }

        var analytics: String {
            return "settings_\(self.rawValue.lowercased())"
        }

        var image: NSImage? {
            let themeSufix = Theme.current == .dark ? "dark" : "light"

            if #available(OSX 11.0, *) {
                let image: NSImage?
                switch self {
                case .general:
                    image = NSImage(named: "settings_general")
                case .shortcuts:
                    image = NSImage(named: "settings_shortcut")
                case .about:
                    image = NSImage(named: "settings_about")
                case .tips:
                    image = NSImage(named: "settings_tips")
                }
                image?.isTemplate = true
                return image
            } else {
                switch self {
                case .general:
                    return NSImage(named: "setting_toolbar_general_\(themeSufix)")
                case .shortcuts:
                    return NSImage(named: "setting_toolbar_shortcuts_\(themeSufix)")
                case .about:
                    return NSImage(named: "setting_toolbar_about")
                case .tips:
                    return NSImage(named: "setting_toolbar_habits_\(themeSufix)")
    //            case .habits:
    //                return NSImage(named: "setting_toolbar_habits_\(themeSufix)")
                }
            }
        }
    }

    private let generalViewController = GeneralSettingsViewController()
    private let shortcutsViewController = ShortcutsSettingsViewController()
    private lazy var tipsViewController = TipsSettingsViewController(topViewController: self)
    private let aboutViewController = AboutSettingsViewController()
    private let habitsViewcontroller = HabitsSettingsViewController()

    private let initialItem: ToolbarItem
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

    init(initialItem: ToolbarItem) {
        self.initialItem = initialItem

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        if #available(OSX 11.0, *) {
            self.window.toolbarStyle = .preference
        }

        guard self.isFirstAppear else {
            return
        }
        self.isFirstAppear = false

        self.toolbar.delegate = self
        self.toolbar.allowsUserCustomization = false
        self.view.window?.toolbar = self.toolbar
        self.setView(for: self.initialItem, animate: false)
//        self.toolbar.sizeMode = .small

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

        self.switchView(for: item, animate: true)
    }

    func switchView(for item: ToolbarItem, animate: Bool) {
        if self.currentItem != item {
            ServiceLocator.shared.analytics.logShowWindow(
                name: item.analytics
            )
        }

        self.setView(for: item, animate: animate)
    }

    func updateFrame(animate: Bool) {
        guard let item = self.currentItem else {
            return
        }

        let newViewController = self.viewController(for: item)
        let newFrame = self.frameFromView(newWiew: newViewController.view)

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

        self.toolbar.selectedItemIdentifier = self.currentItem?.identifier
        self.window.title = newViewController.title ?? ""

        self.updateFrame(animate: animate)
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
        case .tips:
            return self.tipsViewController
//        case .habits:
//            return self.habitsViewcontroller
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
