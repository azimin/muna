//
//  TextTaskCreationView.swift
//  Muna
//
//  Created by Egor Petrov on 20.10.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

final class TextTaskCreationView: View {
    
    let taskCreationView = TaskCreateView(savingProcessingService: ServiceLocator.shared.savingService)

    let taskCreateShortCutsView = TaskCreateShortcuts(style: .withoutShortcutsButton)

    private var isShortcutsViewShowed = false

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        self.setupInitialLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInitialLayout() {
        self.addSubview(self.taskCreationView)
        self.taskCreateShortCutsView.isHidden = true

        self.addSubview(self.taskCreationView)
        self.taskCreationView.snp.makeConstraints { make in
            make.height.equalTo(269)
            make.width.equalTo(211)
        }
    }
}
