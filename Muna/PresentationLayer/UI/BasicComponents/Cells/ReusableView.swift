//
//  ReusableView.swift
//  Muna
//
//  Created by Alexander on 5/5/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

public protocol ReusableComponent: AnyObject {
    func reuse()
}

public protocol ReusableView {
    static var reuseIdentifier: String { get }
    static var bundle: Bundle? { get }
}

extension ReusableView {
    public static var reuseIdentifier: String {
        if let component = String(describing: self).split(separator: ".").last {
            return String(component)
        } else {
            return ""
        }
    }

    public static var bundle: Bundle? {
        return nil
    }
}
