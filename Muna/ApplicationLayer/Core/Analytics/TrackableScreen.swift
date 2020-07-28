//
//  TrackableScreen.swift
//  Muna
//
//  Created by Alexander on 7/28/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

protocol AnalyticsPropertyNameProtocol: AnalyticsValueProtocol {
    var propertiesEventName: String { get }
}

extension AnalyticsPropertyNameProtocol where Self: RawRepresentable, Self.RawValue == String {
    // videoPost -> video_post
    var propertiesEventName: String {
        var string = ""
        for character in self.rawValue {
            if character.isUppercase {
                string += "_\(character.lowercased())"
            } else {
                string += "\(character)"
            }
        }
        return string
    }
}

enum TrackableScreen: String, AnalyticsPropertyNameProtocol {
    case itemsList
    case settings

    // videoPost -> Video Post Showed
    var showEventName: String {
        let words = self.propertiesEventName.components(separatedBy: "_")
        let name = words.map { $0.capitalized }.joined(separator: " ")

        return "\(name) Showed"
    }

    var valueWithFirstLetterCapital: String {
        let initialValue = self.rawValue
        var finalValue = self.rawValue
        if let firstChar = initialValue.first {
            let firstLetter = String(firstChar).capitalized
            finalValue = firstLetter + initialValue.dropFirst()
        }
        return finalValue
    }
}
