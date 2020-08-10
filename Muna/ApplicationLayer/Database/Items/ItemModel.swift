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
    var imageName: String { get }

    var dueDateString: String? { get }
    var dueDate: Date? { get }
    var comment: String? { get }

    var notificationId: String { get }

    var isComplited: Bool { get }
    var isNew: Bool { get }
    var isDeleted: Bool { get }

    func toggleComplited()
    func toggleSeen()
}

class ItemModel: ItemModelProtocol, Codable {
    var id: String
    var imageName: String
    var creationDate: Date

    var numberOfTimeChanges: Int?

    var dueDateString: String?
    var dueDate: Date? {
        didSet {
            self.itemsDatabaseService?.itemUpdated.value = self.id
        }
    }

    var comment: String?

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
                self.completionDate = Date()
            } else {
                ServiceLocator.shared.analytics.increasePersonProperty(
                    name: "number_of_items_completed",
                    by: -1
                )
                ServiceLocator.shared.notifications.sheduleNotification(
                    item: self
                )
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
    }

    weak var itemsDatabaseService: ItemsDatabaseServiceProtocol?

    init(
        id: String,
        imageName: String,
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
        self.creationDate = creationDate
        self.dueDateString = dueDateString
        self.dueDate = dueDate
        self.comment = comment
        self.isComplited = isComplited
        self.isNew = isNew
        self.itemsDatabaseService = itemsDatabaseService
        self.notificationId = UUID().uuidString
    }

    func toggleComplited() {
        self.isComplited.toggle()
    }

    func toggleSeen() {
        self.isNew = false
    }
}
