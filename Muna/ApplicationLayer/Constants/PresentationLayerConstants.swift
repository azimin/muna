//
//  PresentationLayerConstants.swift
//  Muna
//
//  Created by Egor Petrov on 09.08.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

final class PresentationLayerConstants {
    static let oneMinuteInSeconds: Double = 60
    static let oneHourInSeconds: Double = PresentationLayerConstants.oneMinuteInSeconds * 60
    static let oneDayInSeconds: Double = PresentationLayerConstants.oneHourInSeconds * 24
    static let weekInSeconds: Double = PresentationLayerConstants.oneDayInSeconds * 7
    static let oneMonthInSeconds: Double = PresentationLayerConstants.oneDayInSeconds * 31
    static let oneYearInSeconds: Double = PresentationLayerConstants.oneDayInSeconds * 365
}
