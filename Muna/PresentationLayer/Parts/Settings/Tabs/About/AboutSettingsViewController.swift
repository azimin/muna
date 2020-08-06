//
//  AboutSettingsViewController.swift
//  Muna
//
//  Created by Alexander on 8/6/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class AboutSettingsViewController: NSViewController {
    override func loadView() {
        self.view = AboutSettingsView()
    }

    override func viewDidLoad() {
        self.title = "About"
    }
}
