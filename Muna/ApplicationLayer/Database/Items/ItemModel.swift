//
//  PanelItemModel.swift
//  Muna
//
//  Created by Alexander on 5/10/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

protocol ItemModelProtocol {
    var id: String { get }
    var imageName: String? { get }

    var dueDateString: String? { get }
    var dueDate: Date? { get }
    var comment: String? { get }

    var savingType: SavingType? { get }

    var notificationId: String { get }

    var isComplited: Bool { get }
    var isNew: Bool { get }
    var isDeleted: Bool { get }

    func toggleComplited()
    func toggleSeen()
}

class ItemModel: ItemModelProtocol, Codable {
    var id: String
    var imageName: String?
    var creationDate: Date

    var savingType: SavingType?
    var savingTypeCasted: SavingType {
        return self.savingType ?? .screenshot
    }

    var numberOfTimeChanges: Int?
    var commentHeight: CGFloat {
        return self.commentHeightContainer ?? 0
    }
    var commentHeightContainer: CGFloat?

    var dueDateString: String?
    var dueDate: Date? {
        didSet {
            self.itemsDatabaseService?.itemUpdated.value = self.id
        }
    }

    var comment: String? {
        didSet {
            self.calculateNumberOfLines()
        }
    }

    var notificationId: String

    var completionDate: Date?
    var isComplited: Bool {
        didSet {
            if self.isComplited {
                ServiceLocator.shared.analytics.increasePersonProperty(
                    name: "number_of_items_completed",
                    by: 1
                )
                ServiceLocator.shared.notifications.removeNotification(
                    item: self
                )
                self.itemsDatabaseService?.changeNumberOfCompletedItems(value: 1)
                self.completionDate = Date()
            } else {
                ServiceLocator.shared.analytics.increasePersonProperty(
                    name: "number_of_items_completed",
                    by: -1
                )
                ServiceLocator.shared.notifications.sheduleNotification(
                    item: self
                )
                self.itemsDatabaseService?.changeNumberOfCompletedItems(value: -1)
                self.completionDate = nil
            }
            self.itemsDatabaseService?.saveItems()
            self.itemsDatabaseService?.itemUpdated.value = self.id
        }
    }

    var isNew: Bool = false
    var isDeleted: Bool = false

    enum CodingKeys: String, CodingKey {
        case id
        case imageName
        case creationDate
        case completionDate
        case dueDateString
        case dueDate
        case comment
        case numberOfTimeChanges
        case isComplited
        case notificationId
        case commentHeightContainer
    }

    weak var itemsDatabaseService: ItemsDatabaseServiceProtocol?

    init(
        id: String,
        savingType: SavingType?,
        imageName: String?,
        creationDate: Date,
        dueDateString: String?,
        dueDate: Date?,
        comment: String?,
        isComplited: Bool,
        isNew: Bool,
        itemsDatabaseService: ItemsDatabaseServiceProtocol
    ) {
        self.id = id
        self.imageName = imageName
        self.savingType = savingType
        self.creationDate = creationDate
        self.dueDateString = dueDateString
        self.dueDate = dueDate
        self.comment = comment
        self.isComplited = isComplited
        self.isNew = isNew
        self.itemsDatabaseService = itemsDatabaseService
        self.notificationId = UUID().uuidString
        self.calculateNumberOfLines()
    }

    func toggleComplited() {
        self.isComplited.toggle()
    }

    func toggleSeen() {
        self.isNew = false
    }

    private func calculateNumberOfLines() {
        guard let comment = self.comment, comment.isEmpty == false else {
            self.commentHeightContainer = 0
            return
        }

        let width = WindowManager.panelWindowFrameWidth - 16 * 2
        let textWidth = width - MainPanelItemMetainformationStyle.fullSpace

        self.commentHeightContainer = comment.height(
            withConstrainedWidth: textWidth,
            font: MainPanelItemMetainformationStyle.commentFont
        )
    }
}
