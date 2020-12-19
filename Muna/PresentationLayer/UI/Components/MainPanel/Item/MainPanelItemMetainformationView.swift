//
//  MainPanelItemTextView.swift
//  Muna
//
//  Created by Alexander on 6/28/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

enum MainPanelItemMetainformationStyle {
    // DON'T CHANGE CACHING SIZE IS BASE ON IT, ASK ALEX
    static var commentFont = FontStyle.customFont(style: .bold, size: 16)
    // DON'T CHANGE CACHING SIZE IS BASE ON IT, ASK ALEX
    static var commentRightSpacing: CGFloat = 12
    // DON'T CHANGE CACHING SIZE IS BASE ON IT, ASK ALEX
    static var commentToCompleteItemSpacing: CGFloat = 12
    // DON'T CHANGE CACHING SIZE IS BASE ON IT, ASK ALEX
    static var completeItemLeftSpacingSpacing: CGFloat = 12
    // DON'T CHANGE CACHING SIZE IS BASE ON IT, ASK ALEX
    static var completeItemWidth: CGFloat = 19

    static var fullSpace: CGFloat {
        return self.commentRightSpacing + self.commentToCompleteItemSpacing + self.completeItemLeftSpacingSpacing + self.completeItemWidth
    }
}

class MainPanelItemMetainformationView: View {
    static func calculateHeight(item: ItemModel) -> CGFloat {
        var finalHeight: CGFloat = 0
        finalHeight += 12 * 2 + 19 // Size of top/bottom insets and comments
        finalHeight += item.commentHeight // comment
        finalHeight += item.commentHeight > 0 ? 4 : 0 // space between comment and reminder

        return finalHeight
    }

    private static var deadlineFont = FontStyle.customFont(style: .bold, size: 16)

    let metainformationStackView = NSStackView()

    let completionButton = Button().withImageName("reminder-off")

    let deadlineLabel = Label(font: MainPanelItemMetainformationView.deadlineFont)
        .withTextColorStyle(.title80AccentAlpha)

    let commentLabel = Label(font: MainPanelItemMetainformationStyle.commentFont)
        .withTextColorStyle(.titleAccent)

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
            maker.trailing.bottom.equalToSuperview().inset(
                NSEdgeInsets(
                    top: 12,
                    left: 0,
                    bottom: 12,
                    right: MainPanelItemMetainformationStyle.commentRightSpacing
                )
            )
        }

        self.metainformationStackView.addArrangedSubview(self.deadlineLabel)
        self.metainformationStackView.addArrangedSubview(self.commentLabel)

        self.addSubview(self.completionButton)
        self.completionButton.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(
                MainPanelItemMetainformationStyle.completeItemLeftSpacingSpacing
            )

            maker.size.equalTo(
                MainPanelItemMetainformationStyle.completeItemWidth
            )

            maker.trailing.equalTo(self.metainformationStackView.snp.leading).inset(
                -MainPanelItemMetainformationStyle.commentToCompleteItemSpacing
            )

            maker.top.equalTo(self.deadlineLabel.snp.top)
        }
    }

    func updateDueDate(item: ItemModel, style: MainPanelItemView.Style) {
        self.deadlineLabel.stringValue = MainPanelItemMetainformationView.reminderText(
            item: item
        )

        if let dueDate = item.dueDate, dueDate < Date(), style != .completed {
            self.deadlineLabel.textColor = NSColor.color(.redLight)
        } else {
            self.deadlineLabel.textColor = NSColor.color(.title80AccentAlpha)
        }
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

extension String {
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
