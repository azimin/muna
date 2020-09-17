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

    private var remainingTime: CGFloat = 10

    private var timer: Timer?

    override func loadView() {
        self.view = HintView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.rootView.closeButton.target = self
        self.rootView.closeButton.action = #selector(closeHint)
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        self.rootView.addTrackingArea(
            NSTrackingArea(
                rect: self.rootView.bounds,
                options: [.activeAlways, .mouseEnteredAndExited],
                owner: self,
                userInfo: nil
            )
        )

        self.startCountDown()
    }

    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        self.rootView.closeButton.isHidden = false
        self.rootView.countDownView.isHidden = false
        self.timer?.invalidate()
    }

    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        self.rootView.closeButton.isHidden = true
        self.rootView.countDownView.isHidden = false
        self.startCountDown()
    }

    @objc
    private func closeHint() {
        ServiceLocator.shared.windowManager.closeHintPopover()
    }

    private func startCountDown() {
        self.rootView.countDownView.label.text = "\(self.remainingTime)"
        self.timer = Timer(timeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }

            self.remainingTime -= 1

            self.rootView.countDownView.label.text = "\(Int(self.remainingTime))"

            self.rootView.countDownView.countDownLayer.strokeEnd = self.remainingTime / 10

            if self.remainingTime <= 0 {
                self.timer?.invalidate()
                ServiceLocator.shared.windowManager.closeHintPopover()
            }
        }

        guard let timer = timer else { return }
        RunLoop.current.add(timer, forMode: .common)
        timer.fire()
    }
}
