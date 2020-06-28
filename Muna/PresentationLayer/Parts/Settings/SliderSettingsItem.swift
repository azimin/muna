//
//  SliderSettingsItem.swift
//  Muna
//
//  Created by Egor Petrov on 28.06.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

protocol SliderSettingsItemDelegate: AnyObject {
    func sliderValueChanged(_ value: Int)
}

class SliderSettingsItem: View {
    weak var delegate: SliderSettingsItemDelegate?

    let titleLabel = Label(fontStyle: .bold, size: 18)
        .withTextColorStyle(.alwaysWhite)

    let descriptionLabel = Label(fontStyle: .medium, size: 16)
        .withTextColorStyle(.titleAccent)

    let sliderSectionLabel = Label(fontStyle: .medium, size: 14).withTextColorStyle(.titleAccent)
    let slider = NSSlider(value: 3, minValue: 1, maxValue: 4, target: nil, action: nil)

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        self.slider.target = self
        self.slider.action = #selector(self.sliderMoved)
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
            make.width.equalTo(80)
        }

        self.sliderSectionLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalTo(self.slider)
        }

        let viewSector1 = View()
        viewSector1.backgroundColor = ColorStyle.separator.color
        let viewSector2 = View()
        viewSector2.backgroundColor = ColorStyle.separator.color
        let viewSector3 = View()
        viewSector3.backgroundColor = ColorStyle.separator.color
        let viewSector4 = View()
        viewSector4.backgroundColor = ColorStyle.separator.color

        self.addSubview(viewSector1, positioned: .below, relativeTo: self.slider)
        viewSector1.snp.makeConstraints { make in
            make.leading.equalTo(self.slider).offset(6.5)
            make.height.equalTo(21)
            make.width.equalTo(1)
            make.centerY.equalTo(self.slider)
        }

        self.addSubview(viewSector2, positioned: .below, relativeTo: self.slider)
        viewSector2.snp.makeConstraints { make in
            make.leading.equalTo(self.slider).offset(28.5)
            make.height.equalTo(21)
            make.width.equalTo(1)
            make.centerY.equalTo(self.slider)
        }

        self.addSubview(viewSector3, positioned: .below, relativeTo: self.slider)
        viewSector3.snp.makeConstraints { make in
            make.leading.equalTo(self.slider).offset(50.5)
            make.height.equalTo(21)
            make.width.equalTo(1)
            make.centerY.equalTo(self.slider)
        }

        self.addSubview(viewSector4, positioned: .below, relativeTo: self.slider)
        viewSector4.snp.makeConstraints { make in
            make.leading.equalTo(self.slider).offset(72)
            make.height.equalTo(21)
            make.width.equalTo(1)
            make.centerY.equalTo(self.slider)
        }
    }

    @objc func sliderMoved() {
        var newValue = self.slider.doubleValue
        newValue.round(.up)
        switch newValue {
        case 1 ..< 2:
            self.slider.doubleValue = 1
        case 2 ..< 3:
            self.slider.doubleValue = 2
        case 3 ..< 4:
            self.slider.doubleValue = 3
        case 4:
            self.slider.doubleValue = 4
        default:
            break
        }

        self.delegate?.sliderValueChanged(Int(newValue))
    }
}