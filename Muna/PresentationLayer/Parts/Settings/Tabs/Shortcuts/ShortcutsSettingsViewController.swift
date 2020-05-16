//
//  ShortcutsSettingsViewController.swift
//  Muna
//
//  Created by Alexander on 5/16/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class ShortcutsSettingsViewController: NSViewController {
    override func loadView() {
        self.view = ShortcutsSettingsView()
    }

    override func viewDidLoad() {
        self.title = "Shortcuts"
    }
}
