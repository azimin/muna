//
//  MainPanelItem.swift
//  Muna
//
//  Created by Alexander on 5/4/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa
import SnapKit

class MainPanelItemView: View {
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

    func setup() {
        self.addSubview(self.backgroundView)
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
        self.metainformationPlate.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().inset(180)
            maker.bottom.leading.trailing.equalToSuperview()
        }

        self.metainformationPlate.addSubview(self.metainformationStackView)
        self.metainformationStackView.orientation = .vertical
        self.metainformationStackView.spacing = 4
        self.metainformationStackView.alignment = .leading
        self.metainformationStackView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview().inset(NSEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        }

        self.metainformationStackView.addArrangedSubview(self.deadlineLabel)
        self.metainformationStackView.addArrangedSubview(self.commentLabel)
    }
}
