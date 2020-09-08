//
//  ActiveAppCheckService.swift
//  Muna
//
//  Created by Egor Petrov on 27.08.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

enum ActiveApp: String, CaseIterable {
    case reminders = "com.apple.reminders"
    case things = "com.culturedcode.ThingsMac"
    case notes = "com.apple.Notes"
}

protocol ActiveAppCheckServiceProtocol {
    typealias ActiveAppChangedAction = (ActiveApp) -> Void

    func starObservingApps(withAction action: @escaping ActiveAppChangedAction)
}

final class ActiveAppCheckService: ActiveAppCheckServiceProtocol {
    private var observer: NSKeyValueObservation!

    func starObservingApps(withAction action: @escaping ActiveAppChangedAction) {
        self.observer = NSWorkspace.shared.observe(\.frontmostApplication, options: [.initial]) { model, _ in
            guard let bundleId = model.frontmostApplication?.bundleIdentifier, let activeApp = ActiveApp(rawValue: bundleId) else {
                return
            }
            action(activeApp)
        }
    }
}
