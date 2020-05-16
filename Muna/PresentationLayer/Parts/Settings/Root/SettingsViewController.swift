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

        var identifier: NSToolbarItem.Identifier {
            return NSToolbarItem.Identifier(self.rawValue)
        }
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

        let toolbar = NSToolbar(identifier: NSToolbar.Identifier("settings"))
        toolbar.delegate = self
        toolbar.allowsUserCustomization = false

        let item = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier("general"))
        item.label = "General"

        self.view.window?.toolbar = toolbar
    }

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
        toolbarItem.image = NSImage(named: NSImage.preferencesGeneralName)

        return toolbarItem
    }
}
