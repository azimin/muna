//
//  OnboardingFinalSetupViewController.swift
//  Muna
//
//  Created by Alexander on 6/13/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class OnboardingFinalSetupViewController: NSViewController, OnboardingContainerProtocol, ViewHolder {
    typealias ViewType = OnboardingFinalSetupView

    var onNext: VoidBlock?

    override func loadView() {
        self.view = OnboardingFinalSetupView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @objc func buttonAction(sender: NSButton) {
        self.onNext?()
    }
}
