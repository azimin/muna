//
//  MainPanelView.swift
//  Muna
//
//  Created by Alexander on 5/8/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SnapKit

class MainPanelView: NSView {
    let backgroundView = View()
    let visualView = NSVisualEffectView()

    let segmentControl = NSSegmentedControl(labels: ["Uncompleted", "No deadline", "Completed"], trackingMode: .selectOne, target: nil, action: nil)
    let topSeparator = View()
    let mainContentView = MainPanelContentView()

    let bottomSeparator = View()
    let bottomBar = PanelBottomBarView()

    override init(frame: NSRect) {
        super.init(frame: frame)
        self.setup()

        self.window?.makeFirstResponder(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var isFirstLanch = true

    override func layout() {
        super.layout()

        if self.isFirstLanch {
            self.backgroundView.layer?.transform = CATransform3DMakeTranslation(self.frame.width, 0, 0)
            self.isFirstLanch = false
        }
    }

    func setup() {
        self.addSubview(self.backgroundView)
        self.backgroundView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        self.backgroundView.layer?.borderColor = CGColor.color(.separator)
        self.backgroundView.layer?.borderWidth = 0.5

        self.backgroundView.addSubview(self.visualView)
        self.visualView.blendingMode = .behindWindow
        self.visualView.material = .dark
        self.visualView.state = .active
        self.visualView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        self.backgroundView.addSubview(self.segmentControl)
        self.segmentControl.selectedSegment = 0
        self.segmentControl.cell?.controlTint = .defaultControlTint
        self.segmentControl.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(40)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(340)
        }
        self.segmentControl.target = self
        self.segmentControl.action = #selector(self.segmentChanged)

        self.backgroundView.addSubview(self.topSeparator)
        self.topSeparator.backgroundColor = NSColor.color(.separator)
        self.topSeparator.snp.makeConstraints { maker in
            maker.top.equalTo(self.segmentControl.snp.bottom).inset(-16)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(0.5)
        }

        self.backgroundView.addSubview(self.bottomBar)
        self.bottomBar.snp.makeConstraints { maker in
            maker.bottom.equalToSuperview()
            maker.leading.trailing.equalToSuperview()
        }

        self.backgroundView.addSubview(self.bottomSeparator)
        self.bottomSeparator.backgroundColor = NSColor.color(.separator)
        self.bottomSeparator.snp.makeConstraints { maker in
            maker.bottom.equalTo(self.bottomBar.snp.top)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(0.5)
        }

        self.backgroundView.addSubview(self.mainContentView)
        self.mainContentView.snp.makeConstraints { maker in
            maker.top.equalTo(self.topSeparator.snp.bottom)
            maker.bottom.equalTo(self.bottomSeparator.snp.top)
            maker.leading.trailing.equalToSuperview()
        }
    }

    // MARK: - Show/Hide

    @objc
    func segmentChanged() {
        switch self.segmentControl.selectedSegment {
        case 0:
            self.mainContentView.switchContent(filter: .uncompleted)
        case 1:
            self.mainContentView.switchContent(filter: .noDeadline)
        case 2:
            self.mainContentView.switchContent(filter: .completed)
        default:
            assertionFailure("Unsupported index")
        }
    }

    func show() {
        self.backgroundView.layer?.transform = CATransform3DMakeTranslation(self.frame.width, 0, 0)

        let transform = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
        transform.fromValue = self.backgroundView.layer?.transform
        transform.toValue = CATransform3DMakeTranslation(0, 0, 0)
        transform.duration = 0.25

        self.backgroundView.layer?.transform = CATransform3DMakeTranslation(0, 0, 0)
        self.backgroundView.layer?.add(transform, forKey: #keyPath(CALayer.transform))

        self.addMonitor()
        self.mainContentView.reloadData()
    }

    func hide(completion: VoidBlock?) {
        self.mainContentView.popover?.close()

        CATransaction.begin()
        let transform = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
        transform.fromValue = self.backgroundView.layer?.transform
        transform.toValue = CATransform3DMakeTranslation(self.frame.width, 0, 0)
        transform.duration = 0.25

        self.backgroundView.layer?.transform = CATransform3DMakeTranslation(self.frame.width, 0, 0)

        CATransaction.setCompletionBlock(completion)
        self.backgroundView.layer?.add(transform, forKey: #keyPath(CALayer.transform))
        CATransaction.commit()
    }

    var downMonitor: Any?

    func addMonitor() {
        self.downMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: { (event) -> NSEvent? in

            // up
            if event.keyCode == 126 {
                self.mainContentView.selectPreveous(
                    nextSection: event.modifierFlags.contains(.shift)
                )
                return nil
                // down
            } else if event.keyCode == 125 {
                self.mainContentView.selectNext(
                    nextSection: event.modifierFlags.contains(.shift)
                )
                return nil
            }

            return event
           })
    }

    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        // esc
        if event.keyCode == 53 {
            (NSApplication.shared.delegate as? AppDelegate)?.hidePanelIfNeeded()
            return true
        }

        return super.performKeyEquivalent(with: event)
    }

    override func insertText(_ insertString: Any) {
        if let string = insertString as? String, string == " " {
            if self.mainContentView.popUpController.isHidden {
                self.mainContentView.scrollView.stopScroll()
            }
            self.mainContentView.popUpController.toggle()
        } else {
            super.insertText(insertString)
        }
    }
}
