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
        dueDate: Date().addingTimeInterval(60 * 120),
        comment: "Check app",
        path: "App Store",
        image: NSImage(named: NSImage.Name("img_5"))!
    ),
    PanelItemModel(
        dueDate: Date().addingTimeInterval(60 * 20),
        comment: nil,
        path: "Bear",
        image: NSImage(named: NSImage.Name("img_6"))!
    ),
    PanelItemModel(
        dueDate: Date().addingTimeInterval(60 * 23),
        comment: nil,
        path: "Safari/tj",
        image: NSImage(named: NSImage.Name("img_7"))!
    ),
    PanelItemModel(
        dueDate: Date().addingTimeInterval(60 * 24 * 4),
        comment: nil,
        path: "SAfari/dtf",
        image: NSImage(named: NSImage.Name("img_8"))!
    )
]
