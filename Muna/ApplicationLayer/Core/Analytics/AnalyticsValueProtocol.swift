//
//  AnalyticsValueProtocol.swift
//  Muna
//
//  Created by Alexander Zimin on 7/28/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

public protocol AnalyticsValueProtocol {
    var analyticsValue: NSObject { get }
}

extension String: AnalyticsValueProtocol {
    public var analyticsValue: NSObject {
        return self as NSObject
    }
}

extension Int: AnalyticsValueProtocol {
    public var analyticsValue: NSObject {
        return self as NSObject
    }
}

extension Bool: AnalyticsValueProtocol {
    public var analyticsValue: NSObject {
        return self as NSObject
    }
}

extension CGFloat: AnalyticsValueProtocol {
    public var analyticsValue: NSObject {
        return self as NSObject
    }
}

extension Float: AnalyticsValueProtocol {
    public var analyticsValue: NSObject {
        return self as NSObject
    }
}

extension Double: AnalyticsValueProtocol {
    public var analyticsValue: NSObject {
        return self as NSObject
    }
}

extension AnalyticsPropertyNameProtocol {
    var analyticsValue: NSObject {
        return self.propertiesEventName as NSObject
    }
}
