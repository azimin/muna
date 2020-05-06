//
//  PanelItem.swift
//  Muna
//
//  Created by Alexander on 5/5/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

struct PanelItemModel {
    let dueDate: Date
    let comment: String?
    let path: String?
    let image: NSImage
}

var fakeData: [PanelItemModel] = [
    PanelItemModel(
        dueDate: Date().addingTimeInterval(-60 * 69),
        comment: nil,
        path: "Things",
        image: NSImage(named: NSImage.Name("img_1"))!
    ),
    PanelItemModel(
        dueDate: Date().addingTimeInterval(-60 * 25),
        comment: "Make better models",
        path: "Xcode",
        image: NSImage(named: NSImage.Name("img_2"))!
    ),
    PanelItemModel(
        dueDate: Date().addingTimeInterval(60 * 2),
        comment: nil,
        path: "Safari/google",
        image: NSImage(named: NSImage.Name("img_3"))!
    ),
    PanelItemModel(
        dueDate: Date().addingTimeInterval(60 * 60),
        comment: "Clean folders",
        path: "Finder",
        image: NSImage(named: NSImage.Name("img_4"))!
    ),
    PanelItemModel(
        dueDate: Date().addingTimeInterval(60 * 66),
        comment: "Clean folders",
        path: "Finder",
        image: NSImage(named: NSImage.Name("img_9"))!
    ),
    PanelItemModel(
        dueDate: Date().addingTimeInterval(60 * 65),
        comment: "Clean folders",
        path: "Finder",
        image: NSImage(named: NSImage.Name("img_10"))!
    ),
    PanelItemModel(
        dueDate: Date().addingTimeInterval(60 * 120),
        comment: "Check app",
        path: "App Store",
        image: NSImage(named: NSImage.Name("img_5"))!
    ),
    PanelItemModel(
        dueDate: Date().addingTimeInterval(60 * 60 * 20),
        comment: nil,
        path: "Bear",
        image: NSImage(named: NSImage.Name("img_6"))!
    ),
    PanelItemModel(
        dueDate: Date().addingTimeInterval(60 * 60 * 23),
        comment: nil,
        path: "Safari/tj",
        image: NSImage(named: NSImage.Name("img_7"))!
    ),
    PanelItemModel(
        dueDate: Date().addingTimeInterval(60 * 60 * 24 * 4),
        comment: "Some very very long title that will not fit one line",
        path: "Safari/dtf",
        image: NSImage(named: NSImage.Name("img_8"))!
    )
]

extension Array {
    func repeated(count: Int) -> Self {
        assert(count > 0, "count must be greater than 0")

        var result = self
        for _ in 0 ..< count - 1 {
            result += self
        }

        return result
    }
}
