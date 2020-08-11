//
//  PersmissionsService.swift
//  Muna
//
//  Created by Egor Petrov on 11.08.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

protocol PermissionsServiceProtocol {
    var canRecordScreen: Bool { get }

    func checkPermissions() -> Bool
}

final class PermissionsService: PermissionsServiceProtocol {
    var canRecordScreen: Bool {
        guard let windows = CGWindowListCopyWindowInfo([.optionOnScreenOnly], kCGNullWindowID) as? [[String: AnyObject]] else { return false }
        return windows.allSatisfy { window in
            let windowName = window[kCGWindowName as String] as? String
            let isSharingEnabled = window[kCGWindowSharingState as String] as? Int
            return windowName != nil || isSharingEnabled == 1
        }
    }

    func checkPermissions() -> Bool {
        guard self.canRecordScreen else {
            ServiceLocator.shared.windowManager.activateWindowIfNeeded(.permissionsAlert)

            return false
        }

        return true
    }
}
