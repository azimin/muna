//
//  NewMainPanelItemView.swift
//  Muna
//
//  Created by Alexander on 6/28/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SnapKit

final class NewMainPanelItemView: View, GenericCellSubview, ReusableComponent {
    static func calculateHeight(item: ItemModel) -> CGFloat {
        guard let image = ServiceLocator.shared.imageStorage.forceLoadImage(name: item.imageName) else {
            assertionFailure("No image")
            return MainPanelItemMetainformationView.calculateHeight(item: item)
        }

        let maxFrame = CGSize(
            width: WindowManager.panelWindowFrameWidth - 16 * 2,
            height: 162
        )
        let maxRatio = maxFrame.width / maxFrame.height

        let size = image.size
        let ratio = size.width / size.height

        var finalHeight: CGFloat = 0

        if ratio > maxRatio {
            finalHeight = (size.width / ratio) / (size.width / maxFrame.width)
        } else {
            finalHeight = maxFrame.height
        }

        return finalHeight + MainPanelItemMetainformationView.calculateHeight(item: item)
    }

    let backgroundView = View()
    var imageView = ImageView()
    var imageHeightConstraint: Constraint?
    var metainformationHeightConstraint: Constraint?

    let metainformationView = MainPanelItemMetainformationView()

    private var isComplited: Bool = false
    private var itemObservable: ObserverTokenProtocol?

    init() {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reuse() {
        self.item = nil
        self.itemObservable?.removeObserving()
    }

    override func updateLayer() {
        super.updateLayer()
    }

    private func setup() {
        self.addSubview(self.backgroundView)
        self.backgroundView.layer?.cornerRadius = 12
        self.backgroundView.layer?.masksToBounds = true
        self.backgroundView.backgroundColor = NSColor.white.withAlphaComponent(0.15)
        self.backgroundView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(NSEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        }

        self.backgroundView.addSubview(self.imageView)
        self.imageView.imageScaling = .scaleProportionallyUpOrDown
        self.imageView.aspectRation = .resizeAspect
        self.imageView.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview()
            self.imageHeightConstraint = maker.height.equalTo(100).constraint
        }

        self.backgroundView.addSubview(self.metainformationView)
        self.metainformationView.snp.makeConstraints { maker in
            maker.top.equalTo(self.imageView.snp.bottom)
            maker.trailing.leading.bottom.equalToSuperview()
            self.metainformationHeightConstraint = maker.height.equalTo(100).constraint
        }

        self.metainformationView.completionButton.target = self
        self.metainformationView.completionButton.action = #selector(self.toggleCompletion)
    }

    @objc
    func toggleCompletion() {
        self.isComplited.toggle()
        self.item?.isComplited = self.isComplited
        self.updateStyle()
    }

    func updateStyle() {
        let imageName = self.isComplited ? "reminder-on" : "reminder-off"
        self.metainformationView.completionButton.update(
            imageName: imageName,
            colorStyle: .titleAccent
        )
    }

    func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            self.backgroundView.layer?.borderWidth = 3
            self.backgroundView.layer?.borderColor = CGColor.color(.blueSelected)
        } else {
            self.backgroundView.layer?.borderWidth = 0
            self.backgroundView.layer?.borderColor = CGColor.color(.title60AccentAlpha)
        }
    }

    private var item: ItemModel?

    func update(item: ItemModel) {
        self.metainformationView.updateDueDate(item: item)

        if let comment = item.comment, comment.isEmpty == false {
            self.metainformationView.commentLabel.isHidden = false
        } else {
            self.metainformationView.commentLabel.isHidden = true
        }

        let metainfoHeight = MainPanelItemMetainformationView.calculateHeight(item: item)
        self.imageHeightConstraint?.update(
            offset: NewMainPanelItemView.calculateHeight(item: item) - metainfoHeight
        )
        self.metainformationHeightConstraint?.update(
            offset: metainfoHeight
        )

        self.metainformationView.commentLabel.stringValue = item.comment ?? ""
        self.isComplited = item.isComplited

        let image = ServiceLocator.shared.imageStorage.forceLoadImage(name: item.imageName)
        self.imageView.image = image

        self.item = item
        item.toggleSeen()

        self.updateStyle()

        self.itemObservable = ServiceLocator.shared.itemsDatabase.itemUpdated.observe(self, closure: { [weak self] _, id in
            guard let self = self else { return }
            if id != nil, self.item?.id == id {
                self.isComplited = item.isComplited
                self.updateStyle()
                self.metainformationView.updateDueDate(item: item)
            }
        })
    }
}
