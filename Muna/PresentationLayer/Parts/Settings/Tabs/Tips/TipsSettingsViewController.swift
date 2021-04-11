//
//  TipsSettingsViewController.swift
//  Muna
//
//  Created by Alexander on 3/30/21.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Cocoa

class TipsSettingsViewController: NSViewController {
    let topViewController: SettingsViewController

    init(topViewController: SettingsViewController) {
        self.topViewController = topViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = TipsSettingsView()
        (self.view as? TipsSettingsView)?.topViewController = topViewController
    }

    override func viewDidLoad() {
        self.title = "Tips"
    }
}
