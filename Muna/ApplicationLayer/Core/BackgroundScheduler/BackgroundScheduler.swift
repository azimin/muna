//
//  BackgroundScheduler.swift
//  Muna
//
//  Created by Egor Petrov on 15.04.2021.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Foundation

struct TaskConfiguration {

    let repeats: Bool

    let interval: TimeInterval

    let tolerance: TimeInterval

    let qualityOfService: QualityOfService

    static let `default` = TaskConfiguration(
        repeats: true,
        interval: PresentationLayerConstants.oneHourInSeconds * 8,
        tolerance: PresentationLayerConstants.oneHourInSeconds,
        qualityOfService: .utility
    )
}

enum BackgroundTaskKey: String {

    case subscriptionValidationTask = "com.abstract.muna.subscription"
}

protocol BackgroundSchedulerProtocol {

    func addActivity(byKey key: BackgroundTaskKey, withConfig config: TaskConfiguration, action: @escaping VoidBlock)

    func invalidate(byKey key: BackgroundTaskKey)
}

final class BackgroundScheduler: BackgroundSchedulerProtocol {

    private var tasks: [BackgroundTaskKey: NSBackgroundActivityScheduler] = [:]

    func addActivity(byKey key: BackgroundTaskKey, withConfig config: TaskConfiguration = .default, action: @escaping VoidBlock) {
        if tasks[key] != nil {
            self.tasks[key]?.invalidate()
            self.tasks[key] = nil
        }

        let task = NSBackgroundActivityScheduler(identifier: key.rawValue)
        task.repeats = config.repeats
        task.interval = config.interval
        task.tolerance = config.tolerance
        task.qualityOfService = config.qualityOfService
        task.schedule { completion in
            action()
            completion(.finished)
        }
        self.tasks[key] = task
    }

    func invalidate(byKey key: BackgroundTaskKey) {
        self.tasks[key]?.invalidate()
        self.tasks[key] = nil
    }
}
