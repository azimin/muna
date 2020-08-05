//
//  Date+Time.swift
//  Muna
//
//  Created by Alexander on 5/24/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation
import SwiftDate

extension Date {
    func timeSmartString(showMinutes: Bool) -> String {
        if showMinutes {
            if self.is24Hour {
                return self.toFormat("HH:mm")
            } else {
                return self.toFormat("h:mm a")
            }
        } else {
            if self.is24Hour {
                return self.toFormat("HH:mm")
            } else {
                return self.toFormat("h a")
            }
        }
    }

    var is24Hour: Bool {
        guard let dateFormat = DateFormatter.dateFormat(
            fromTemplate: "j",
            options: 0,
            locale: Locale.current
        ) else {
            appAssertionFailure("Some problem")
            return false
        }
        return dateFormat.firstIndex(of: "a") == nil
    }
}
