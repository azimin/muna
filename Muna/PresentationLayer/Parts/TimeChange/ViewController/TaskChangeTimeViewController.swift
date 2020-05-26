//
//  TaskChangeTimeViewController.swift
//  Muna
//
//  Created by Alexander on 5/26/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class TaskChangeTimeViewController: NSViewController {
    let taskView: TaskChangeTimeView

    let itemModel: ItemModel

    init(itemModel: ItemModel) {
        self.itemModel = itemModel
        self.taskView = TaskChangeTimeView(itemModel: itemModel)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = NSView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.taskView)
        self.taskView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
}
