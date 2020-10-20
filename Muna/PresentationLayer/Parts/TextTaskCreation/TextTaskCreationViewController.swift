//
//  TextTaskCreationViewController.swift
//  Muna
//
//  Created by Egor Petrov on 20.10.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

final class TextTaskCreationViewController: NSViewController, ViewHolder {
    typealias ViewType = TaskCreateView

    override func loadView() {
        self.view = TaskCreateView(savingProcessingService: ServiceLocator.shared.savingService)
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        ServiceLocator.shared.analytics.logEvent(name: "Text Task Creation Showed")
    }
}
