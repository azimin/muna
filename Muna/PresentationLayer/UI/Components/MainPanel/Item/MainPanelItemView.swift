//
//  MainPanelItem.swift
//  Muna
//
//  Created by Alexander on 5/4/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SnapKit

final class MainPanelItemView: View, GenericCellSubview {
    let backgroundView = View()

    let imageView = ImageView()
    let metainformationPlate = NSVisualEffectView()
    let metainformationStackView = NSStackView()

    let deadlineLabel = Label(fontStyle: .heavy, size: 16)
    let commentLabel = Label(fontStyle: .medium, size: 14)

    init() {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.addSubview(self.backgroundView)
        self.backgroundView.layer?.borderWidth = 1
        self.backgroundView.layer?.borderColor = CGColor.color(.white60alpha)
        self.backgroundView.layer?.cornerRadius = 12
        self.backgroundView.layer?.masksToBounds = true
        self.backgroundView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview().inset(NSEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        }

        self.backgroundView.addSubview(self.imageView)
        self.imageView.imageScaling = .scaleProportionallyUpOrDown
        self.imageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }

        self.backgroundView.addSubview(self.metainformationPlate)
        self.metainformationPlate.blendingMode = .withinWindow
        self.metainformationPlate.material = .dark
        self.metainformationPlate.state = .active
        self.metainformationPlate.layer?.maskedCorners = [
            .layerMaxXMinYCorner, .layerMinXMinYCorner
        ]
        self.metainformationPlate.layer?.cornerRadius = 12
        self.metainformationPlate.wantsLayer = true
        self.metainformationPlate.maskImage = NSImage(color: .black, size: .init(width: 1, height: 1))

        self.metainformationPlate.snp.makeConstraints { (maker) in
            maker.bottom.leading.trailing.equalToSuperview()
        }

        self.metainformationPlate.addSubview(self.metainformationStackView)
        self.metainformationStackView.orientation = .vertical
        self.metainformationStackView.spacing = 4
        self.metainformationStackView.alignment = .leading
        self.metainformationStackView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview().inset(NSEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        }

        self.deadlineLabel.textColor = NSColor.color(.white)
        self.metainformationStackView.addArrangedSubview(self.deadlineLabel)

        self.commentLabel.textColor = NSColor.color(.white60alpha)
        self.metainformationStackView.addArrangedSubview(self.commentLabel)
    }

    func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            self.backgroundView.layer?.borderWidth = 3
            self.backgroundView.layer?.borderColor = CGColor.color(.blueSelected)
        } else {
            self.backgroundView.layer?.borderWidth = 1
            self.backgroundView.layer?.borderColor = CGColor.color(.white60alpha)
        }
    }

    func update(item: PanelItemModel) {
        self.deadlineLabel.stringValue = "End in: \(item.dueDate)"

        if let comment = item.comment, comment.isEmpty == false {
            self.commentLabel.isHidden = false
        } else {
            self.commentLabel.isHidden = true
        }

        if item.dueDate < Date() {
            self.deadlineLabel.textColor = NSColor.color(.redLight)
        } else {
            self.deadlineLabel.textColor = NSColor.color(.white)
        }

        self.commentLabel.stringValue = item.comment ?? ""
        self.imageView.image = item.image
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
