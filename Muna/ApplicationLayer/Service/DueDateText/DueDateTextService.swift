//
//  DueDateTextService.swift
//  Muna
//
//  Created by azimin on 22.07.2021.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Foundation

protocol DueDateTextServiceProtocol {
    func requstDueDatePlaceholder() -> String
    func newItemCreated(dueDateUsed: Bool)
}

class DueDateTextService: DueDateTextServiceProtocol {
    typealias Hint = (text: String, isPro: Bool)
    var hints: [Hint] = [
        ("Set due date (optional) (in 2h)", false),
        ("Set due date (optional) (tomorrow)", false),
        ("Set due date (optional) (2 pm)", false),
        ("Set due date (optional) (evening)", false),
        ("Set due date (optional) (in 2 days)", false),
        ("Set due date (optional) (weekends)", false),
        ("Set due date (next monday 10 am)", true),
        ("Set due date (in 3 days in the morning)", true),
    ]
    
    func requstDueDatePlaceholder() -> String {
        let index = Preferences.usedDueDateTextIndex
        
        if index >= self.hints.count {
            Preferences.usedDueDateTextIndex = 0
            return self.hints[0].text
        }
        
        let hint = self.hints[index]
        
        if hint.isPro && Preferences.usedDueDateOnItem == false {
            Preferences.usedDueDateTextIndex = 0
            return self.hints[0].text
        }
        
        return hint.text
    }
    
    func newItemCreated(dueDateUsed: Bool) {
        if dueDateUsed {
            Preferences.usedDueDateOnItem = true
        }
        Preferences.usedDueDateTextIndex += 1
    }
}
