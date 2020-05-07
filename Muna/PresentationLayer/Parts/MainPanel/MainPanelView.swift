//
//  MainPanelView.swift
//  Muna
//
//  Created by Alexander on 5/8/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SnapKit

// swiftlint:disable type_body_length
class MainPanelView: NSView {
    let backgroundView = View()
    let visualView = NSVisualEffectView()
    let mainContentView = MainPanelContentView()

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

        if isFirstLanch {
            self.backgroundView.layer?.transform = CATransform3DMakeTranslation(self.frame.width, 0, 0)
            self.isFirstLanch = false
        }
    }

    func setup() {
        self.addSubview(self.backgroundView)
        self.backgroundView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        self.backgroundView.layer?.borderColor = NSColor.gray.cgColor
        self.backgroundView.layer?.borderWidth = 0.5

        self.backgroundView.addSubview(self.visualView)
        self.visualView.blendingMode = .behindWindow
        self.visualView.material = .dark
        self.visualView.state = .active
        self.visualView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }

        self.backgroundView.addSubview(self.mainContentView)
        self.mainContentView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview().inset(
                NSEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
            )
        }
    }

    // MARK: - Show/Hide

       func show() {
           self.backgroundView.layer?.transform = CATransform3DMakeTranslation(self.frame.width, 0, 0)

           let transform = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
           transform.fromValue = self.backgroundView.layer?.transform
           transform.toValue = CATransform3DMakeTranslation(0, 0, 0)
           transform.duration = 0.25

           self.backgroundView.layer?.transform = CATransform3DMakeTranslation(0, 0, 0)
           self.backgroundView.layer?.add(transform, forKey: #keyPath(CALayer.transform))

           self.addMonitor()
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
                self.mainContentView.selectPreveous()
                   return nil
                   // down
               } else if event.keyCode == 125 {
                self.mainContentView.selectNext()
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
