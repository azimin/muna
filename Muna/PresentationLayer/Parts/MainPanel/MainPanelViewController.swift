//
//  MainPanelViewController.swift
//  Muna
//
//  Created by Alexander on 5/5/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class MainPanelViewController: NSViewController {
    override func loadView() {
      self.view = MainPanelView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.becomeFirstResponder()
    }

    override func keyDown(with event: NSEvent) {
        print("Swag")
    }
}
