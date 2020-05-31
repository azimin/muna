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

    let imageContentView = View()
    let imageView = ImageView()
    let taskView: TaskChangeTimeView

    let itemModel: ItemModel
    let style: Style

    init(itemModel: ItemModel, style: Style, closeHandler: CloseHandler?) {
        self.itemModel = itemModel
        self.style = style

        self.taskView = TaskChangeTimeView(
            itemModel: itemModel,
            closeHandler: closeHandler
        )

        super.init(frame: .zero)

        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateLayer() {
        super.updateLayer()
        self.imageContentView.layer?.borderColor = CGColor.color(.separator)
    }

    func setup() {
        self.imageContentView.layer?.cornerRadius = 16
        self.imageContentView.layer?.masksToBounds = true
        self.imageContentView.layer?.borderWidth = 1

        switch self.style {
        case .withImage:
            self.addSubview(self.imageContentView)
            self.imageContentView.snp.makeConstraints { maker in
                maker.top.equalToSuperview()
                maker.centerX.equalToSuperview()
                maker.size.equalTo(CGSize(width: 175, height: 116))
            }

            self.imageContentView.addSubview(self.imageView)
            self.imageView.snp.makeConstraints { maker in
                maker.edges.equalToSuperview()
            }

            self.addSubview(self.taskView)
            self.taskView.snp.makeConstraints { maker in
                maker.top.equalTo(self.imageView.snp.bottom).inset(-12)
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
