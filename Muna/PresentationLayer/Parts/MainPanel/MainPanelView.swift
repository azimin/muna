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
    let visualOverlayView = View()
        .withBackgroundColorStyle(.lightForegroundOverlay)

    let segmentControl = NSSegmentedControl(labels: ["Uncompleted", "No deadline", "Completed"], trackingMode: .selectOne, target: nil, action: nil)
    let topSeparator = View()
        .withBackgroundColorStyle(.separator)
    let mainContentView = MainPanelContentView()

    let bottomSeparator = View()
        .withBackgroundColorStyle(.separator)
    let bottomBar = PanelBottomBarView()

    var hintView: PanelHintView?

    override init(frame: NSRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateLayer() {
        super.updateLayer()
        self.visualView.material = Theme.current.visualEffectMaterial
        self.backgroundView.layer?.borderColor = CGColor.color(.separator)
    }

    func setup() {
        self.addSubview(self.backgroundView)
        self.backgroundView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        self.backgroundView.layer?.borderWidth = 0.5

        self.backgroundView.addSubview(self.visualView)
        self.visualView.blendingMode = .behindWindow
        self.visualView.state = .active
        self.visualView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        self.backgroundView.addSubview(self.visualOverlayView)
        self.visualOverlayView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        self.backgroundView.addSubview(self.segmentControl)
        self.segmentControl.selectedSegment = 0
        self.segmentControl.segmentStyle = .capsule
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
//            self.showHint()
        default:
            appAssertionFailure("Unsupported index")
        }
    }

    func show(selectedItem: ItemModel? = nil) {
        if let item = selectedItem {
            self.toggle(selectedItem: item)
        } else {
            self.mainContentView.reloadData(selectedItem: selectedItem)
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

    // MARK: - Hint

    private func showHint() {
        self.hintView?.removeFromSuperview()
        let hintView = PanelHintView(hintItem: .previewImage)
        self.addSubview(hintView)
        hintView.snp.makeConstraints { maker in
            maker.bottom.equalTo(self.mainContentView.snp.bottom).inset(12)
            maker.leading.trailing.equalToSuperview().inset(12)
            maker.height.equalTo(250)
        }

        self.hintView = hintView
    }
}
