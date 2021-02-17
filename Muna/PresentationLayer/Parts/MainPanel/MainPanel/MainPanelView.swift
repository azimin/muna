//
//  MainPanelView.swift
//  Muna
//
//  Created by Alexander on 5/8/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SnapKit
import SwiftDate

class MainPanelView: MainPanelBackgroundView {
    let segmentControl = NSSegmentedControl(labels: ["Uncompleted", "No deadline", "Completed"], trackingMode: .selectOne, target: nil, action: nil)
    let topSeparator = View()
        .withBackgroundColorStyle(.separator)
    let mainContentView = MainPanelContentView()

    let bottomSeparator = View()
        .withBackgroundColorStyle(.separator)
    let bottomBar = PanelBottomBarView()

    var closePanelTime = Date()

    override func viewSetup() {
        super.viewSetup()

        self.backgroundView.addSubview(self.segmentControl)
        self.segmentControl.selectedSegment = 0

        if #available(OSX 11.0, *) { } else {
            self.segmentControl.segmentStyle = .capsule
        }

        self.segmentControl.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(18)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(340)
        }
        self.segmentControl.target = self
        self.segmentControl.action = #selector(self.segmentChanged)

        self.backgroundView.addSubview(self.topSeparator)
        self.topSeparator.snp.makeConstraints { maker in
            maker.top.equalTo(self.segmentControl.snp.bottom).inset(-18)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(1)
        }

        self.backgroundView.addSubview(self.bottomBar)
        self.bottomBar.snp.makeConstraints { maker in
            maker.bottom.equalToSuperview()
            maker.leading.trailing.equalToSuperview()
        }

        self.backgroundView.addSubview(self.bottomSeparator)
        self.bottomSeparator.snp.makeConstraints { maker in
            maker.bottom.equalTo(self.bottomBar.snp.top)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(1)
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
            appAssertionFailure("Unsupported index")
        }
    }

    func show(selectedItem: ItemModel? = nil) {
        if let item = selectedItem {
            self.toggle(selectedItem: item)
        } else {
            self.switchToFirstTabIfNeeded()
            self.mainContentView.reloadData(selectedItem: nil)
        }
    }

    func toggle(selectedItem: ItemModel? = nil) {
        guard let item = selectedItem else {
            return
        }

        if let filter = ServiceLocator.shared.itemsDatabase.itemFilter(by: item.id) {
            switch filter {
            case .completed:
                self.segmentControl.selectedSegment = 2
            case .uncompleted:
                self.segmentControl.selectedSegment = 0
            default:
                appAssertionFailure("No segment")
            }
        }

        self.mainContentView.reloadData(selectedItem: item)
    }

    func hide() {
        self.mainContentView.popover?.close()
        self.closePanelTime = Date()
    }

    func switchToFirstTabIfNeeded() {
        if abs(self.closePanelTime.timeIntervalSince(Date())) > 60 {
            self.segmentControl.selectedSegment = 0
        }
    }

    func spaceClicked() {
        ServiceLocator.shared.analytics.executeControl(
            control: .itemPreview,
            byShortcut: true
        )

        if self.mainContentView.popUpController.isHidden {
            self.mainContentView.scrollView.stopScroll()
        }
        self.mainContentView.popUpController.toggle()
    }
}
