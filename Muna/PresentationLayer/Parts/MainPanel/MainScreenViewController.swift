//
//  MainPanelViewController.swift
//  Muna
//
//  Created by Alexander on 5/5/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class MainScreenViewController: NSViewController {
    var shortcutsController: ShortcutsController?

    var panelView: MainPanelView {
        return (self.view as! MainScreenView).mainPanelView
    }

    var rootView: MainScreenView {
        return (self.view as! MainScreenView)
    }

    override func loadView() {
        self.view = MainScreenView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.panelView.bottomBar.tipsView.isHidden = true

        var shortcutActions: [ShortcutAction] = []
        for shortcut in Shortcut.allCases {
            shortcutActions.append(.init(
                item: shortcut.item,
                action: { [weak self] in
                    self?.actionForShortcut(shortcut)
                }
            ))
        }

        self.shortcutsController = ShortcutsController(
            shortcutActions: shortcutActions
        )

        self.rootView.shortcutsView.closeButton.target = self
        self.rootView.shortcutsView.closeButton.action = #selector(self.shortcutAction)

        self.panelView.bottomBar.settingsButton.target = self
        self.panelView.bottomBar.settingsButton.action = #selector(self.settingAction)

        self.panelView.bottomBar.shortcutsButton.target = self
        self.panelView.bottomBar.shortcutsButton.action = #selector(self.shortcutAction)

        self.panelView.mainContentView.delegate = self

        self.panelView.bottomBar.tipsView.pressAction = {
            ServiceLocator.shared.windowManager.activateWindowIfNeeded(.settings(item: .tips))
        }
    }

    var lastPulseAnimation: Date?

    override func viewWillAppear() {
        super.viewWillAppear()

        self.panelView.bottomBar.tipsView.isHidden = !ServiceLocator.shared.inAppPurchaseManager.isNeededToShowTips()

        if self.lastPulseAnimation == nil || self.lastPulseAnimation?.isToday == false {
            self.panelView.bottomBar.tipsView.runPulseAnimation()
            self.lastPulseAnimation = Date()
        }
    }

    func toggleSmartAssistent() {
        if self.smartAssistenIsOpen {
            self.hideSmartAssistentIfNeeded()
        } else {
            self.showSmartAssistentIfNeeded()
        }
    }

    private var smartAssistenIsOpen = false

    private func showSmartAssistentIfNeeded() {
        guard !self.smartAssistenIsOpen else {
            return
        }
        self.rootView.assistenPanelPresentationView.show()
        self.smartAssistenIsOpen = true
    }

    private func hideSmartAssistentIfNeeded() {
        guard self.smartAssistenIsOpen else {
            return
        }
        self.rootView.assistenPanelPresentationView.hide(completion: nil)
        self.smartAssistenIsOpen = false
    }

    @objc func settingAction() {
        (NSApplication.shared.delegate as? AppDelegate)?.windowManager.activateWindowIfNeeded(.settings(item: .general))
    }

    @objc func shortcutAction() {
        self.showShortcutsView()
    }

    func actionForShortcut(_ shortcut: Shortcut) {
        switch shortcut {
        case .showSmartAssistent:
            self.toggleSmartAssistent()
        case .nextItem:
            self.panelView.mainContentView.selectNext(
                nextSection: false
            )
        case .preveousItem:
            self.panelView.mainContentView.selectPreveous(
                nextSection: false
            )
        case .nextSection:
            self.panelView.mainContentView.selectNext(
                nextSection: true
            )
        case .preveousSection:
            self.panelView.mainContentView.selectPreveous(
                nextSection: true
            )
        case .deleteItem:
            self.panelView.mainContentView.deleteActiveItemAction(byShortcut: true)
        case .previewItem:
            self.panelView.spaceClicked()
        case .complete:
            self.panelView.mainContentView.completeActiveItemAction(byShortcut: true)
        case .editTime:
            self.panelView.mainContentView.editReminder(byShortcut: true)
        case .copyImage:
            self.panelView.mainContentView.copyAction(byShortcut: true)
        case .close:
            if self.panelView.mainContentView.closePopUpIfNeeded() == false {
                if self.smartAssistenIsOpen {
                    self.toggleSmartAssistent()
                } else {
                    ServiceLocator.shared.windowManager.hideWindowIfNeeded(.panel(selectedItem: nil))
                }
            }
        case .nextTab:
            self.panelView.nextSegment()
        case .preveousTab:
            self.panelView.preveousSegment()
        }
    }

    // MARK: - Show/Hide

    func show(selectedItem: ItemModel? = nil) {
        self.view.window?.makeFirstResponder(self.view)

        self.panelView.show(selectedItem: selectedItem)
        self.rootView.mainPanelPresentationView.show()
        self.shortcutsController?.start()

        MousePositionService.shared.start()
    }

    func showShortcutsView() {
        self.view.window?.makeFirstResponder(self.view)

        self.rootView.toggleShortutsView()
    }

    func toggle(selectedItem: ItemModel? = nil) {
        self.panelView.toggle(selectedItem: selectedItem)
    }

    func hide(completion: VoidBlock?) {
        self.panelView.hide()
        self.rootView.mainPanelPresentationView.hide(completion: completion)
        self.hideSmartAssistentIfNeeded()
        self.rootView.hideShortcutsView()
        self.rootView.hideChangeTimeView()

        self.shortcutsController?.stop()

        MousePositionService.shared.stop()
    }

    // MARK: - Shorcuts

    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        if self.shortcutsController?.performKeyEquivalent(with: event) == true {
            return true
        } else {
            return super.performKeyEquivalent(with: event)
        }
    }

    override func insertText(_ insertString: Any) {
        if self.shortcutsController?.insertText(insertString) == false {
            super.insertText(insertString)
        }
    }
}

extension MainScreenViewController: MainPanelContentViewDelegate {
    func mainPanelContentViewShouldShowTimeChange(itemModel: ItemModel) {
        self.rootView.showChangeTimeView(
            itemModel: itemModel,
            closeHandler: CloseHandler(close: { [weak self] in
                self?.rootView.hideChangeTimeView()
                self?.shortcutsController?.start()
            })
        )
        self.shortcutsController?.stop()
    }

    func mainPanelContentViewShouldShowCommentChange(itemModel: ItemModel) {
        self.rootView.showChangeCommentView(
            itemModel: itemModel,
            closeHandler: CloseHandler(close: { [weak self] in
                self?.rootView.hideChangeCommentView()
                self?.shortcutsController?.start()
            })
        )
        self.shortcutsController?.stop()
    }
}
