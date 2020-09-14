//
//  HintViewController.swift
//  Muna
//
//  Created by Egor Petrov on 14.09.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class HintViewController: NSViewController, ViewHolder {
    typealias ViewType = HintView

    override func loadView() {
        self.view = HintView()
    }
}
