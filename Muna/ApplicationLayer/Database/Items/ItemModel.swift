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

    func toggleComplited()
}

class ItemModel: Codable {
    var id: String
    var imageName: String
    var creationDate: Date

    var dueDateString: String?
    var dueDate: Date?
    var comment: String?

    var isComplited: Bool

    init(
        id: String,
        imageName: String,
        creationDate: Date,
        dueDateString: String?,
        dueDate: Date?,
        comment: String?,
        isComplited: Bool
    ) {
        self.id = id
        self.imageName = imageName
        self.creationDate = creationDate
        self.dueDateString = dueDateString
        self.dueDate = dueDate
        self.comment = comment
        self.isComplited = isComplited
    }

    func toggleComplited() {
        self.isComplited.toggle()
    }
}
