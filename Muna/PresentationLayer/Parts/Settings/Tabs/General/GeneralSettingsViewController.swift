//
//  GeneralSettingsViewController.swift
//  Muna
//
//  Created by Alexander on 5/16/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class GeneralSettingsViewController: NSViewController {
    override func loadView() {
        self.view = GeneralSettingsView()
    }

    override func viewDidLoad() {
        self.title = "General"
    }
}
