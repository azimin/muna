//
//  MainPanelItemTextView.swift
//  Muna
//
//  Created by Alexander on 6/28/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

class MainPanelItemMetainformationView: View {
    static func calculateHeight(item: ItemModel) -> CGFloat {
        let width = WindowManager.panelWindowFrameWidth - 16 * 2 - 12 * 2
        let textWidth = width - 12 * 2 - 19

        var finalHeight: CGFloat = 0

        let reminderText = MainPanelItemMetainformationView.reminderText(item: item)
        finalHeight += reminderText.height(
            withConstrainedWidth: textWidth,
            font: MainPanelItemMetainformationView.deadlineFont
        )

        if let comment = item.comment, comment.isEmpty == false {
            finalHeight += 4
            finalHeight += comment.height(
                withConstrainedWidth: textWidth,
                font: MainPanelItemMetainformationView.commentFont
            )
        }

        return finalHeight + 12 * 2
    }

    private static var deadlineFont = FontStyle.customFont(style: .heavy, size: 16)
    private static var commentFont = FontStyle.customFont(style: .medium, size: 14)

    let metainformationStackView = NSStackView()

    let completionButton = Button().withImageName("reminder-off")

    let deadlineLabel = Label(font: MainPanelItemMetainformationView.deadlineFont)
        .withTextColorStyle(.titleAccent)

    let commentLabel = Label(font: MainPanelItemMetainformationView.commentFont)
        .withTextColorStyle(.title60AccentAlpha)

    init() {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.addSubview(self.metainformationStackView)
        self.metainformationStackView.orientation = .vertical
        self.metainformationStackView.spacing = 4
        self.metainformationStackView.alignment = .leading
        self.metainformationStackView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(12)
            maker.trailing.bottom.equalToSuperview().inset(NSEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
        }

        self.metainformationStackView.addArrangedSubview(self.deadlineLabel)
        self.metainformationStackView.addArrangedSubview(self.commentLabel)

        self.addSubview(self.completionButton)
        self.completionButton.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(12)
            maker.size.equalTo(19)
            maker.trailing.equalTo(self.metainformationStackView.snp.leading).inset(-12)
            maker.top.equalTo(self.deadlineLabel.snp.top)
        }
    }

    func updateDueDate(item: ItemModel) {
        self.deadlineLabel.stringValue = MainPanelItemMetainformationView.reminderText(
            item: item
        )
    }

    private static func reminderText(item: ItemModel) -> String {
        if let dueDate = item.dueDate {
            let reminder = CardPreviewDateFormatter(date: dueDate)
            return reminder.reminderText
        } else {
            return "No reminder"
        }
    }
}

private extension String {
    func height(withConstrainedWidth width: CGFloat, font: NSFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: NSFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )

        return ceil(boundingBox.width)
    }
}
