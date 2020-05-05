//
//  DateParser.swift
//  Muna
//
//  Created by Egor Petrov on 04.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

enum Constants {
    enum Time: String {
        case minute
        case minutes
        case hour
        case hours
        case h
        case weekends
    }
}

struct DetectorResult {
    let date: Date
    let stringRange: NSRange
}

protocol DateInStringDetectorProtocol {

    func processDateFrom(string: String) -> [DetectorResult]?
}

class DateInStringDetector: DateInStringDetectorProtocol {

    private let datePattern = """
    \\b(\\w*(in)\\w*) \\d*\\s*(\\w*(\(Constants.Time.minute.rawValue)
    |\(Constants.Time.minutes.rawValue)
    |\(Constants.Time.hour.rawValue)
    |\(Constants.Time.hours.rawValue)
    |\(Constants.Time.h.rawValue)
    |\(Constants.Time.weekends.rawValue)))\\b
    """

    private let dataDetector: NSDataDetector
    private let regularExpressionProcessor: NSRegularExpression

    init() throws {
        self.dataDetector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
        self.regularExpressionProcessor = try NSRegularExpression(pattern: self.datePattern, options: [.caseInsensitive])
    }

    func processDateFrom(string: String) -> [DetectorResult]? {
        if let dateMatch = self.dataDetector.matches(
            in: string,
            options: [],
            range: NSRange(location: 0, length: string.utf16.count)
        ).last, let date = dateMatch.date {
            return [DetectorResult(date: date, stringRange: dateMatch.range)]
        }

        return self.processDateByRegularExpression(from: string)
    }

    private func processDateByRegularExpression(from string: String) -> [DetectorResult]? {
        var results: [DetectorResult]?
        guard let match = regularExpressionProcessor.matches(
            in: string,
            options: [],
            range: NSRange(location: 0, length: string.utf16.count)
        ).last else {
            return nil
        }

        let foundSubstring = (string as NSString).substring(with: match.range)
        let digits = Int(foundSubstring.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
        let timeString: String?
        if digits == nil {
            timeString = foundSubstring.components(separatedBy: " ").last?.trimmingCharacters(in: .whitespaces)
        } else {
            timeString = foundSubstring.components(separatedBy: CharacterSet.decimalDigits).last?.trimmingCharacters(in: .whitespaces)
        }
        let time = Constants.Time(rawValue: timeString ?? "")
        print("\(digits) \(time)")
        return nil
    }
}
