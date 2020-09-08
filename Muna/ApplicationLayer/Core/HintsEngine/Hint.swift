//
//  Hint.swift
//  Muna
//
//  Created by Alexander on 8/24/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

enum HintLevel {
    case basic
    case normal
    case advanced
}

enum HintContent {
    case none
    case shortcut(shortcutItem: ShortcutItem)
    case image(image: NSImage)
    case video(name: String, aspectRatio: CGFloat)
    case multiply(content: [HintContent])
}

struct Hint {
    let level: HintLevel
    let id: String
    let text: String
    let content: HintContent
    let available: () -> Bool
}
