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
        .withTextColorStyle(.newTitle)

    let descriptionLabel = Label(fontStyle: .medium, size: 16)
        .withTextColorStyle(.newTitle)

    let sliderSectionLabel = Label(fontStyle: .medium, size: 14)
    let slider = NSSlider(value: 3, minValue: 1, maxValue: 4, target: nil, action: nil)

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview()
        }

        self.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
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
            make.width.equalTo(120)
        }

        self.sliderSectionLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalTo(self.slider)
        }
    }
}
