//
//  NSView+StyleHolder.swift
//  Muna
//
//  Created by Alexander on 5/18/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

typealias StyleUpdateAction = (_ style: ColorStyle) -> Void

private class ObjectHolder {
    weak var owner: AnyObject?
    var action: StyleUpdateAction
    var defaultStyle: ColorStyle

    init(owner: AnyObject, defaultStyle: ColorStyle, action: @escaping StyleUpdateAction) {
        self.owner = owner
        self.defaultStyle = defaultStyle
        self.action = action

        self.action(defaultStyle)
    }

    func update() {
        self.action(self.defaultStyle)
    }
}

extension NSView {
    private static var _myComputedProperty = [String: ObjectHolder]()

    static func updateAllStyles() {
        for (key, value) in NSView._myComputedProperty where value.owner == nil {
            NSView._myComputedProperty[key] = nil
        }

        for value in NSView._myComputedProperty.values {
            value.update()
        }
    }

    func createStyleAction(style: ColorStyle, action: @escaping StyleUpdateAction) {
        for (key, value) in NSView._myComputedProperty where value.owner == nil {
            NSView._myComputedProperty[key] = nil
        }

        let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))

        if NSView._myComputedProperty[tmpAddress] != nil {
            assertionFailure("Style already exists")
        }

        NSView._myComputedProperty[tmpAddress] = ObjectHolder(
            owner: self,
            defaultStyle: style,
            action: action
        )
    }
}
