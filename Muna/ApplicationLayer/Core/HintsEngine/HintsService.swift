//
//  HintsService.swift
//  Muna
//
//  Created by Alexander on 8/24/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

protocol HintsServiceProtocol {
    func executeHintItem(item: HintItem)
    func hideHint(item: HintItem)
    func requestHintIfNeeded() -> HintItem?
}

class HintsService: HintsServiceProtocol {
    func executeHintItem(item: HintItem) {}

    func hideHint(item: HintItem) {}

    func requestHintIfNeeded() -> HintItem? {
        return nil
    }
}
