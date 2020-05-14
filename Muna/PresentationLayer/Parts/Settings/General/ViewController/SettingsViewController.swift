//
//  SettingsViewController.swift
//  Muna
//
//  Created by Alexander on 5/14/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class SettingsViewController: NSViewController, NSToolbarDelegate {
    override func loadView() {
        self.view = SettingsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let toolbar = NSToolbar(identifier: NSToolbar.Identifier("settings"))
        self.view.window?.toolbar = toolbar
        toolbar.delegate = self

        let item = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier("general"))
        item.label = "General"
    }
}
