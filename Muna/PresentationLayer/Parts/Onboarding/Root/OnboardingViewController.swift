//
//  OnboardingViewController.swift
//  Muna
//
//  Created by Alexander on 6/13/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

protocol OnboardingContainerProtocol {
    var onNext: VoidBlock? { get set }
}

typealias OnboardingContainerViewController = OnboardingContainerProtocol & NSViewController

class OnboardingViewController: NSViewController, NSToolbarDelegate {
    enum Step: String, CaseIterable, AnalyticsPropertyNameProtocol {
        case intro
        case howToCapture
        case howToRemind
        case howToSeeItems
        case howToGetReminder
        case final

        func next() -> Step {
            if let index = Step.allCases.firstIndex(of: self) {
                if index < (Step.allCases.count - 1) {
                    return Step.allCases[index + 1]
                } else {
                    return .final
                }
            }
            return .final
        }
    }

    private var currentStep: Step?
    private var currentViewController: NSViewController?

    var window: NSWindow {
        return self.view.window!
    }

    override func loadView() {
        self.view = OnboardingView()
    }

    var isFirstAppear = true

    override func viewDidAppear() {
        super.viewDidAppear()

        guard self.isFirstAppear else {
            return
        }
        self.isFirstAppear = false
        self.setView(for: .intro, animate: false)

        self.window.makeKeyAndOrderFront(nil)
        self.window.center()
    }

    // MARK: - Control

    func setView(for step: Step, animate: Bool) {
        if let index = Step.allCases.firstIndex(of: step) {
            ServiceLocator.shared.analytics.reachOnboardingStep(
                step: index,
                stepType: step
            )
        }

        if let oldItem = self.currentStep, let oldViewController = self.currentViewController {
            if oldItem == step {
                return
            }

            oldViewController.view.removeFromSuperview()
            oldViewController.removeFromParent()
        }

        self.currentStep = step

        var newViewController = self.viewController(for: step)
        newViewController.onNext = { [weak self] in
            self?.setView(for: step.next(), animate: true)
        }
        let newFrame = self.frameFromView(newWiew: newViewController.view)

        self.window.setFrame(newFrame, display: true, animate: animate)
        self.addChild(newViewController)
        self.window.contentView?.addSubview(newViewController.view)

        newViewController.view.frame = CGRect(
            x: 0,
            y: 0,
            width: newFrame.width,
            height: newFrame.height
        )
        self.currentViewController = newViewController
    }

    // MARK: - Helpers

    private func viewController(for step: Step) -> OnboardingContainerViewController {
        switch step {
        case .intro:
            return OnboardingIntroViewController()
        case .howToCapture:
            return OnboardingStepViewController(style: .howToCapture)
        case .howToRemind:
            return OnboardingStepViewController(style: .howToRemind)
        case .howToSeeItems:
            return OnboardingStepViewController(style: .howToSeeItems)
        case .howToGetReminder:
            return OnboardingStepViewController(style: .howToGetReminder)
        case .final:
            return OnboardingFinalSetupViewController()
        }
    }

    private func frameFromView(newWiew: NSView) -> NSRect {
        var oldFrame = self.window.frame
        var newSize = newWiew.fittingSize
        newSize.height += self.window.titlebarHeight

        oldFrame.origin = NSPoint(
            x: oldFrame.origin.x - (newSize.width - oldFrame.width) / 2,
            y: oldFrame.origin.y - (newSize.height - oldFrame.height) / 2
        )
        oldFrame.size = newSize

        return oldFrame
    }
}
