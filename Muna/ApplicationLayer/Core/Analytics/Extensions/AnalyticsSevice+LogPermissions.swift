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
}
