//
//  MainPanelItem.swift
//  Muna
//
//  Created by Alexander on 5/4/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SnapKit

final class MainPanelItemView: View, GenericCellSubview, ReusableComponent {
    let backgroundView = View()

    var imageView = ImageView()
    let metainformationPlate = NSVisualEffectView()
    let metainformationPlateOverlay = View()
    let metainformationStackView = NSStackView()

    let completionButton = Button().withImageName("reminder-off")
    let deadlineLabel = Label(fontStyle: .heavy, size: 16)
    let commentLabel = Label(fontStyle: .medium, size: 14)

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
        self.metainformationPlate.material = Theme.current.visualEffectMaterial
        self.metainformationPlateOverlay.backgroundColor = NSColor.color(.lightForegroundOverlay)

        self.deadlineLabel.textColor = NSColor.color(.titleAccent)
        self.commentLabel.textColor = NSColor.color(.title60AccentAlpha)
    }

    private func setup() {
        self.addSubview(self.backgroundView)
        self.backgroundView.layer?.borderWidth = 1
        self.backgroundView.layer?.cornerRadius = 12
        self.backgroundView.layer?.masksToBounds = true
        self.backgroundView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(NSEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        }

        self.backgroundView.addSubview(self.imageView)
        self.imageView.imageScaling = .scaleProportionallyUpOrDown
        self.imageView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        self.backgroundView.addSubview(self.metainformationPlate)
        self.metainformationPlate.blendingMode = .withinWindow
        self.metainformationPlate.state = .active
        self.metainformationPlate.layer?.maskedCorners = [
            .layerMaxXMinYCorner, .layerMinXMinYCorner,
        ]
        self.metainformationPlate.layer?.cornerRadius = 12
        self.metainformationPlate.wantsLayer = true
        self.metainformationPlate.maskImage = NSImage(color: .black, size: .init(width: 1, height: 1))

        self.metainformationPlate.snp.makeConstraints { maker in
            maker.bottom.leading.trailing.equalToSuperview()
        }

        self.metainformationPlate.addSubview(self.metainformationPlateOverlay)
        self.metainformationPlateOverlay.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        self.metainformationPlate.addSubview(self.metainformationStackView)
        self.metainformationStackView.orientation = .vertical
        self.metainformationStackView.spacing = 4
        self.metainformationStackView.alignment = .leading
        self.metainformationStackView.snp.makeConstraints { maker in
            maker.top.trailing.bottom.equalToSuperview().inset(NSEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        }

        self.metainformationStackView.addArrangedSubview(self.deadlineLabel)
        self.metainformationStackView.addArrangedSubview(self.commentLabel)

        self.metainformationPlate.addSubview(self.completionButton)
        self.completionButton.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(12)
            maker.size.equalTo(19)
            maker.trailing.equalTo(self.metainformationStackView.snp.leading).inset(-12)
            maker.top.equalTo(self.deadlineLabel.snp.top)
        }

        self.completionButton.target = self
        self.completionButton.action = #selector(self.toggleCompletion)
    }

    @objc
    func toggleCompletion() {
        self.isComplited.toggle()
        self.item?.isComplited = self.isComplited
        self.updateStyle()
    }

    func updateStyle() {
        let imageName = self.isComplited ? "reminder-on" : "reminder-off"
        _ = self.completionButton.withImageName(imageName, color: .titleAccent)
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
        if let dueDate = item.dueDate {
            self.deadlineLabel.stringValue = "End in: \(dueDate)"
        } else {
            self.deadlineLabel.stringValue = "No reminder"
        }

        if let comment = item.comment, comment.isEmpty == false {
            self.commentLabel.isHidden = false
        } else {
            self.commentLabel.isHidden = true
        }

        if let dueDate = item.dueDate, dueDate < Date() {
            self.deadlineLabel.textColor = NSColor.color(.redLight)
        } else {
            self.deadlineLabel.textColor = NSColor.color(.titleAccent)
        }

        self.commentLabel.stringValue = item.comment ?? ""
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
            }
        })
    }
}

extension NSImage {
    convenience init(color: NSColor, size: NSSize) {
        self.init(size: size)
        lockFocus()
        color.drawSwatch(in: NSRect(origin: .zero, size: size))
        unlockFocus()
    }
}
