//
//  Theme.swift
//  Muna
//
//  Created by Alexander on 5/16/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

private var currentTheme = Theme.current

enum Theme: String {
    case dark
    case light

    static var current: Theme {
        let type = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light"
        if type == "Dark" {
            return .dark
        } else if type == "Light" {
            return .light
        } else {
            assertionFailure("No style")
            return .dark
        }
    }

    var visualEffectMaterial: NSVisualEffectView.Material {
        switch self {
        case .dark:
            return .dark
        case .light:
            return .light
        }
    }

    static func checkThemeUpdateIfNeeded() {
        if currentTheme != Theme.current {
            NSView.updateAllStyles()
            currentTheme = Theme.current
        }
    }
}
