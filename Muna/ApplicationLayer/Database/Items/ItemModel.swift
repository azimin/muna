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

    var isComplited: Bool { get }
    var isNew: Bool { get }

    func toggleComplited()
    func toggleSeen()
}

class ItemModel: Codable {
    var id: String
    var imageName: String
    var creationDate: Date

    var dueDateString: String?
    var dueDate: Date?
    var comment: String?

    var completionDate: Date?
    var isComplited: Bool {
        didSet {
            if self.isComplited {
                self.completionDate = Date()
            } else {
                self.completionDate = nil
            }
            self.itemsDatabaseService?.saveItems()
        }
    }

    var isNew: Bool = false

    enum CodingKeys: String, CodingKey {
        case id
        case imageName
        case creationDate
        case dueDateString
        case dueDate
        case comment
        case isComplited
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
    }

    func toggleComplited() {
        self.isComplited.toggle()
    }

    func toggleSeen() {
        self.isNew = false
    }
}
