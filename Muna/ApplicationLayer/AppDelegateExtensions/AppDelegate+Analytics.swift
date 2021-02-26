//
//  AppDelegate+Analytics.swift
//  Muna
//
//  Created by Alexander on 7/28/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

extension AppDelegate {
    func logAnalytics() {
        ServiceLocator.shared.analytics.logLaunchEvents()
    }
}
