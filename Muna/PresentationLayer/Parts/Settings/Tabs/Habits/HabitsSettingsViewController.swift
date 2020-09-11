//
//  HabitsSettingsViewController.swift
//  Muna
//
//  Created by Egor Petrov on 11.09.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class HabitsSettingsViewController: NSViewController {
    override func loadView() {
        self.view = AboutSettingsView()
    }

    override func viewDidLoad() {
        self.title = "About"
    }
}
