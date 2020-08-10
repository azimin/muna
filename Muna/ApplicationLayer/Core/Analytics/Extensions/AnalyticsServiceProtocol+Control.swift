//
//  AnalyticsServiceProtocol+Control.swift
//  Muna
//
//  Created by Alexander on 8/10/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

enum AnalyticsControl: String, AnalyticsPropertyNameProtocol {
    case itemPreview
    case itemCopy
    case itemEditTime
    case itemComplete
    case itemDelete
    case itemCreate
    case panelShortcuts
    case captureShortcuts
}

extension AnalyticsServiceProtocol {
    func reachOnboardingStep(step: Int, stepType: OnboardingViewController.Step) {
        self.logEvent(
            name: "Onboarding Step Showed",
            properties: [
                "step": step,
                "step_type": stepType,
            ]
        )
    }

    func executeControl(control: AnalyticsControl, byShortcut: Bool) {
        self.logEvent(
            name: "Control Executed",
            properties: [
                "type": control.propertiesEventName,
                "by_shortcut": byShortcut,
            ]
        )
    }
}
