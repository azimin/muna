//
//  SliderSettingsItem.swift
//  Muna
//
//  Created by Egor Petrov on 28.06.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class SliderSettingsItem: View {
    let titleLabel = Label(fontStyle: .bold, size: 18)
        .withTextColorStyle(.titleAccent)

    let descriptionLabel = Label(fontStyle: .medium, size: 16)
        .withTextColorStyle(.title60Accent)

    let sliderSectionLabel = Label(fontStyle: .medium, size: 14).withTextColorStyle(.titleAccent)
    let slider = NSSlider(value: 2, minValue: 0, maxValue: 4, target: nil, action: nil)

    var sliderSectionsViews = [View]()

    init(minValue: Double, maxValue: Double) {
        self.slider.minValue = minValue
        self.slider.maxValue = maxValue

        super.init(frame: .zero)

        self.layer?.masksToBounds = false
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layout() {
        super.layout()
        let sliderSectorWidth = self.slider.frame.size.width / CGFloat(self.slider.maxValue + 1)
        let markPositionInSector = sliderSectorWidth / 2 - 0.5

        for sector in Int(self.slider.minValue) ... Int(self.slider.maxValue) {
            let view = self.sliderSectionsViews[sector]
            let xPosition = sliderSectorWidth * CGFloat(sector + 1) - markPositionInSector + self.slider.frame.minX
            let yPosition = self.slider.frame.midY - 10.5
            let point = CGPoint(x: xPosition, y: yPosition)
            view.frame = CGRect(origin: point, size: CGSize(width: 1, height: 21))
            view.layoutSubtreeIfNeeded()
            self.sliderSectionsViews[sector] = view
        }
    }

    func setup() {
        for sector in 0 ... Int(self.slider.maxValue) {
            let view = View()
            view.backgroundColor = ColorStyle.separator.color
            self.addSubview(view, positioned: .below, relativeTo: self.slider)
            self.sliderSectionsViews.append(view)
        }

        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview()
        }

        self.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(4)
        }

        self.addSubview(self.sliderSectionLabel)
        self.sliderSectionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
        }

        self.addSubview(self.slider)
        self.slider.trackFillColor = ColorStyle.blueSelected.color
        self.slider.snp.makeConstraints { make in
            make.top.equalTo(self.sliderSectionLabel.snp.bottom).offset(4)
            make.trailing.equalToSuperview()
            make.width.equalTo(80)
        }

        self.sliderSectionLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalTo(self.slider)
        }
    }
}
