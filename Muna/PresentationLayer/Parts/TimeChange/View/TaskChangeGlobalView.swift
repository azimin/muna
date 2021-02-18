//
//  TaskChangeTimeViewController.swift
//  Muna
//
//  Created by Alexander on 5/26/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class TaskChangeGlobalView: View {
    enum Style {
        case editTimeWithImage
        case editTimeWithoutImage
        case editCommentWithImage
        case editCommentWithoutImage

        var isEditTime: Bool {
            switch self {
            case .editTimeWithImage, .editTimeWithoutImage:
                return true
            case .editCommentWithImage, .editCommentWithoutImage:
                return false
            }
        }
    }

    let imageContentView = View()
    let imageView = ImageView()
    let taskView: TaskChangeTimeView?
    let taskChangeCommentView: TaskChangeCommentView?

    let itemModel: ItemModel
    let style: Style

    init(itemModel: ItemModel, style: Style, closeHandler: CloseHandler?) {
        self.itemModel = itemModel
        self.style = style

        if self.style.isEditTime {
            self.taskView = TaskChangeTimeView(
                itemModel: itemModel,
                closeHandler: closeHandler
            )
            self.taskChangeCommentView = nil
        } else {
            self.taskChangeCommentView = TaskChangeCommentView(
                itemModel: itemModel,
                closeHandler: closeHandler
            )
            self.taskView = nil
        }

        super.init(frame: .zero)

        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateLayer() {
        super.updateLayer()
    }

    func setup() {
        switch self.style {
        case .editTimeWithImage, .editCommentWithImage:
            guard let imageName = self.itemModel.imageName else {
                appAssertionFailure("No image")
                return
            }

            let image = ServiceLocator.shared.imageStorage.forceLoadImage(
                name: imageName
            )
            self.imageView.image = image
            self.imageView.layer?.cornerRadius = 4

            let imageSideInstet: CGFloat = 12

            self.addSubview(self.imageContentView)
            self.imageContentView.snp.makeConstraints { maker in
                maker.top.equalToSuperview()
                maker.centerX.equalToSuperview()
                if let size = image?.size {
                    if size.width > size.height * 1.48 {
                        let coef = (320 - imageSideInstet * 2) / size.width
                        let height = (size.height * coef)
                        maker.width.equalTo(320)
                        maker.height.equalTo(height)
                    } else {
                        let coef = 200 / size.height
                        let width = (size.width * coef)
                        maker.width.equalTo(width + imageSideInstet * 2)
                        maker.height.equalTo(200)
                    }
                }
            }

            self.imageContentView.addSubview(self.imageView)
            self.imageView.snp.makeConstraints { maker in
                maker.edges.equalToSuperview().inset(NSEdgeInsets(top: 0, left: imageSideInstet, bottom: 0, right: imageSideInstet))
            }
        case .editTimeWithoutImage, .editCommentWithoutImage:
            break
        }

        switch self.style {
        case .editTimeWithImage:
            if let taskView = self.taskView {
                self.addSubview(taskView)
                taskView.snp.makeConstraints { maker in
                    maker.top.equalTo(self.imageContentView.snp.bottom).inset(-12)
                    maker.leading.trailing.bottom.equalToSuperview()
                }
            }
        case .editTimeWithoutImage:
            if let taskView = self.taskView {
                self.addSubview(taskView)
                taskView.snp.makeConstraints { maker in
                    maker.edges.equalToSuperview()
                }
            }
        case .editCommentWithImage:
            if let taskChangeCommentView = self.taskChangeCommentView {
                self.addSubview(taskChangeCommentView)
                taskChangeCommentView.snp.makeConstraints { maker in
                    maker.top.equalTo(self.imageContentView.snp.bottom).inset(-12)
                    maker.leading.trailing.bottom.equalToSuperview()
                }
            }
        case .editCommentWithoutImage:
            if let taskChangeCommentView = self.taskChangeCommentView {
                self.addSubview(taskChangeCommentView)
                taskChangeCommentView.snp.makeConstraints { maker in
                    maker.edges.equalToSuperview()
                }
            }
        }
    }
}
