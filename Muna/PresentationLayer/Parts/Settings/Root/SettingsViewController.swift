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

        var identifier: NSToolbarItem.Identifier {
            return NSToolbarItem.Identifier(self.rawValue)
        }

        var image: NSImage? {
            switch self {
            case .general:
                return NSImage(named: NSImage.preferencesGeneralName)
            case .shortcuts:
                return NSImage(named: NSImage.slideshowTemplateName)
            }
        }
    }

    private let generalViewController = GeneralSettingsViewController()
    private let shortcutsViewController = GeneralSettingsViewController()

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

    override func viewDidAppear() {
        super.viewDidAppear()

        guard self.isFirstAppear else {
            return
        }
        self.isFirstAppear = false

        self.toolbar.delegate = self
        self.toolbar.allowsUserCustomization = false

        let item = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier("general"))
        item.label = "General"

        self.view.window?.toolbar = self.toolbar
        self.setView(for: .general, animate: false)
    }

    // MARK: - Control

    @objc
    func switchToolbarItem(_ toolbarItem: NSToolbarItem) {
        guard let item = ToolbarItem(rawValue: toolbarItem.itemIdentifier.rawValue) else {
            assertionFailure("No supported item")
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

        self.window.setFrame(newFrame, display: true, animate: animate)
        self.window.contentView?.addSubview(newViewController.view)
    }

    // MARK: - Helpers

    private func viewController(for item: ToolbarItem) -> NSViewController {
        switch item {
        case .general:
            return self.generalViewController
        case .shortcuts:
            return self.shortcutsViewController
        }
    }

    private func frameFromView(newWiew: NSView) -> NSRect {
        let oldFrame = self.window.frame
        var newFrame = self.window.frameRect(forContentRect: newWiew.frame)

        newFrame.origin = NSPoint(
            x: oldFrame.origin.x,
            y: oldFrame.origin.y - (newFrame.size.height - oldFrame.size.height)
        )

        return newFrame
    }

    // MARK: - Toolbar

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return ToolbarItem.allCases.map { $0.identifier }
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return ToolbarItem.allCases.map { $0.identifier }
    }

    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        guard let item = ToolbarItem(rawValue: itemIdentifier.rawValue) else {
            assertionFailure("Not correct identifier")
            return nil
        }

        let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
        toolbarItem.label = item.rawValue
        toolbarItem.image = item.image
        toolbarItem.action = #selector(self.switchToolbarItem(_:))

        return toolbarItem
    }
}
