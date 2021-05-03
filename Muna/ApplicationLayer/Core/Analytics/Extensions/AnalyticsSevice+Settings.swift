//
//  AnalyticsSevice+LogPermissions.swift
//  Muna
//
//  Created by Egor Petrov on 11.08.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

extension AnalyticsServiceProtocol {
    func logCapturePermissions(isEnabled: Bool) {
        self.setPersonProperty(name: "screen_capture_permissions", value: isEnabled)
    }

    func logSetShowNumberOfUncomplitedItems(isShow: Bool) {
        self.setPersonProperty(name: "is_showing_number_of_uncompleted_items", value: isShow)
    }

    func logLaunchOnStartup(shouldLaunch: Bool) {
        self.setPersonProperty(name: "launch_on_startup", value: shouldLaunch)
    }
}
