//
//  TimeParserTests.swift
//  Muna
//
//  Created by Alexander on 5/18/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation
import SwiftDate

class TimeParserTests {
    static func test() {
        let currentTime = TimeZone.current.secondsFromGMT()
        let date = Date() + currentTime.seconds
        print("\(MunaChrono().parseFromString("In 4h", date: date))\n")
//        print("\(MunaChrono().parseFromString("Tomorrow", date: date))\n")
//        print("\(MunaChrono().parseFromString("tomorrow", date: date))\n")
//        print("\(MunaChrono().parseFromString("Yesterday at 5pm", date: date))\n")
//        print("\(MunaChrono().parseFromString("5.30", date: date))\n")
//        print("\(MunaChrono().parseFromString("5.30am", date: date))\n")
//        print("\(MunaChrono().parseFromString("In 1.5h", date: date))\n")
//        print("\(MunaChrono().parseFromString("On sun", date: date)))\n")
//        print("\(MunaChrono().parseFromString("Wed 8:30 pm", date: date)))\n")
//        print("\(MunaChrono().parseFromString("Next Friday 8 30 pm", date: date)))\n")
    }
}
