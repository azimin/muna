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
