//
//  TipsSettingsViewController.swift
//  Muna
//
//  Created by Alexander on 3/30/21.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Cocoa

class TipsSettingsViewController: NSViewController {
    override func loadView() {
        self.view = TipsSettingsView()
    }

    override func viewDidLoad() {
        self.title = "Tips"
    }
}
