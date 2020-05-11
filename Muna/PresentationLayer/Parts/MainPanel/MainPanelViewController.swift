//
//  MainPanelViewController.swift
//  Muna
//
//  Created by Alexander on 5/5/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class MainPanelViewController: NSViewController {
    var rootView: MainPanelView {
        return self.view as! MainPanelView
    }

    override func loadView() {
        self.view = MainPanelView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.rootView.bottomBar.settingsButton.target = self
        self.rootView.bottomBar.settingsButton.action = #selector(self.settingAction)

        self.rootView.bottomBar.shortcutsButton.target = self
        self.rootView.bottomBar.shortcutsButton.action = #selector(self.shortcutAction)
    }

    @objc func settingAction() {
        print("Settings")
    }

    @objc func shortcutAction() {
        print("Shortcut")
    }
}
