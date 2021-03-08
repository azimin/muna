//
//  OnboardingAnalyticsViewController.swift
//  Muna
//
//  Created by Egor Petrov on 07.03.2021.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Foundation

class OnboardingAnalyticsViewController: NSViewController, OnboardingContainerProtocol, ViewHolder {
    enum Usage {
        case onboarding
        case standalone
    }

    typealias ViewType = OnboardingAnalyticsView

    var onNext: VoidBlock?

    private let usage: Usage

    init(usage: Usage) {
        self.usage = usage
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = OnboardingAnalyticsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.rootView.settingsSwitcher.switcher.checked = true
        Preferences.shouldUseAnalytics = true
        ServiceLocator.shared.replaceAnalytics(shouldUseAnalytics: Preferences.shouldUseAnalytics, force: false)

        switch self.usage {
        case .onboarding:
            self.rootView.countinueButton.title = "Next"
        case .standalone:
            self.rootView.countinueButton.title = "Done"
        }
    }

    @objc
    private func handleAnalyticsSwitcher() {
        Preferences.shouldUseAnalytics = self.rootView.settingsSwitcher.switcher.checked
        ServiceLocator.shared.replaceAnalytics(shouldUseAnalytics: Preferences.shouldUseAnalytics, force: false)
    }
}
