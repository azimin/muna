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

        switch self.usage {
        case .onboarding:
            self.rootView.settingsSwitcher.switcher.checked = true
            self.rootView.countinueButton.title = "Next"
        case .standalone:
            self.rootView.settingsSwitcher.switcher.checked = Preferences.shouldUseAnalytics
            self.rootView.countinueButton.title = "Done"
        }

        self.rootView.countinueButton.target = self
        self.rootView.countinueButton.action = #selector(buttonAction)
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        
        Preferences.isNeededToShowAnalytics = false
    }

    @objc
    private func handleAnalyticsSwitcher() {
        ServiceLocator.shared.replaceAnalytics(
            shouldUseAnalytics: self.rootView.settingsSwitcher.switcher.checked,
            force: false
        )
    }

    @objc func buttonAction(sender: NSButton) {
        handleAnalyticsSwitcher()

        switch self.usage {
        case .onboarding:
            self.onNext?()
        case .standalone:
            ServiceLocator.shared.windowManager.toggleWindow(.analtyics)
        }
    }
}
