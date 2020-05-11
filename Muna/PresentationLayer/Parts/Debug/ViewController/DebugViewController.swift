//
//  DebugViewController.swift
//  Muna
//
//  Created by Alexander on 5/11/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class DebugViewController: NSViewController {
    override func loadView() {
        self.view = DebugView()
    }
}
