//
//  CheckboxWithImageSettingView.swift
//  Muna
//
//  Created by Egor Petrov on 08.09.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

final class CheckboxWithImageSettingView: View {
    let imageView = ImageView()

    let checkboxButton = Button(checkboxWithTitle: "", target: nil, action: nil)

    init(image: NSImage?, title: String, initialState: NSControl.StateValue) {
        super.init(frame: .zero)

        self.imageView.image = image
        self.imageView.aspectRation = .resizeAspect
        self.imageView.layer?.masksToBounds = false
        self.layer?.masksToBounds = false

        self.checkboxButton.title = title
        self.checkboxButton.state = initialState

        self.setupInitialLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayout() {
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.leading.top.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(60)
        }

        self.addSubview(self.checkboxButton)
        self.checkboxButton.snp.makeConstraints { make in
            make.top.equalTo(self.imageView.snp.bottom).offset(10)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
}
