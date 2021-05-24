//
//  DateItemPresentationConfigurator.swift
//  Muna
//
//  Created by Alexander on 5/18/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

protocol DateItemPresentationConfiguratorProtocol {
    func transform(timeType: TimeType, preferedAmount: Int) -> [TimeOfDay]
}

class BasicDateItemPresentationConfigurator: DateItemPresentationConfiguratorProtocol {
    func transform(timeType: TimeType, preferedAmount: Int) -> [TimeOfDay] {
        switch timeType {
        case let .specificTime(timeOfDay):
            return [timeOfDay]
        case .afertnoon:
            if preferedAmount == 1 {
                return [TimeOfDay(hours: 15, minutes: 0, seconds: 0)]
            } else {
                return [
                    TimeOfDay(hours: 15, minutes: 0, seconds: 0),
                    TimeOfDay(hours: 17, minutes: 0, seconds: 0),
                ]
            }
        case .evening:
            if preferedAmount == 1 {
                return [TimeOfDay(hours: 19, minutes: 0, seconds: 0)]
            } else {
                return [
                    TimeOfDay(hours: 19, minutes: 0, seconds: 0),
                    TimeOfDay(hours: 20, minutes: 0, seconds: 0),
                ]
            }
        case .mindnight:
            return [TimeOfDay(hours: 23, minutes: 30, seconds: 0)]
        case .morning:
            if preferedAmount == 1 {
                return [TimeOfDay(hours: 10, minutes: 0, seconds: 0)]
            } else if preferedAmount == 2 {
                return [
                    TimeOfDay(hours: 9, minutes: 0, seconds: 0),
                    TimeOfDay(hours: 10, minutes: 0, seconds: 0),
                ]
            } else {
                return [
                    TimeOfDay(hours: 9, minutes: 0, seconds: 0),
                    TimeOfDay(hours: 10, minutes: 0, seconds: 0),
                    TimeOfDay(hours: 11, minutes: 0, seconds: 0),
                ]
            }
        case .noon:
            return [TimeOfDay(hours: 12, minutes: 0, seconds: 0)]
        case .allDay:
            if preferedAmount == 1 {
                return [TimeOfDay(hours: 12, minutes: 0, seconds: 0)]
            } else {
                return [
                    TimeOfDay(hours: 12, minutes: 0, seconds: 0),
                    TimeOfDay(hours: 20, minutes: 0, seconds: 0),
                ]
            }
        }
    }
}
