//
//  TaskChangeTimeViewController.swift
//  Muna
//
//  Created by Alexander on 5/26/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class TaskChangeTimeGlobalView: View {
    enum Style {
        case withImage
        case withoutImage
    }

    let imageView = ImageView()
    let taskView: TaskChangeTimeView

    let itemModel: ItemModel
    let style: Style

    init(itemModel: ItemModel, style: Style) {
        self.itemModel = itemModel
        self.style = style

        self.taskView = TaskChangeTimeView(itemModel: itemModel)

        super.init(frame: .zero)

        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        switch self.style {
        case .withImage:
            self.addSubview(self.imageView)
            self.taskView.snp.makeConstraints { maker in
                maker.top.equalToSuperview()
                maker.centerX.equalToSuperview()
                maker.size.equalTo(CGSize(width: 175, height: 116))
            }

            self.addSubview(self.taskView)
            self.taskView.snp.makeConstraints { maker in
                maker.top.equalTo(self.taskView.snp.bottom).inset(-12)
                maker.leading.trailing.bottom.equalToSuperview()
            }
        case .withoutImage:
            self.addSubview(self.taskView)
            self.taskView.snp.makeConstraints { maker in
                maker.edges.equalToSuperview()
            }
        }

        self.imageView.image = ServiceLocator.shared.imageStorage.forceLoadImage(
            name: self.itemModel.imageName
        )
    }
}
