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

        self.rootView.startupSettingItem.switcher.state = Preferences.launchOnStartup ? .on : .off

        self.rootView.startupSettingItem.switcher.target = self
        self.rootView.startupSettingItem.switcher.action = #selector(self.switchStateChanged)
    }

    @objc func buttonAction(sender: NSButton) {
        self.onNext?()
    }

    @objc
    func switchStateChanged() {
        Preferences.launchOnStartup = self.rootView.startupSettingItem.switcher.state == .on
    }
}
