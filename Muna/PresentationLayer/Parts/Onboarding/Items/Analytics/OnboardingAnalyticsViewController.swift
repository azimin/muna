//
//  OnboardingAnalyticsViewController.swift
//  Muna
//
//  Created by Egor Petrov on 07.03.2021.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Foundation

class OnboardingAnalyticsViewController: NSViewController, OnboardingContainerProtocol, ViewHolder {
    typealias ViewType = OnboardingAnalyticsView

    var onNext: VoidBlock?

    override func loadView() {
        self.view = OnboardingAnalyticsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.rootView.settingsSwitcher.switcher.checked = true
        Preferences.shouldUseAnalytics = true
    }

    @objc
    private func handleAnalyticsSwitcher() {
        Preferences.shouldUseAnalytics = self.rootView.settingsSwitcher.switcher.checked
    }
}
