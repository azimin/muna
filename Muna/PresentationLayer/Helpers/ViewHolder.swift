//
//  ViewHolder.swift
//  Muna
//
//  Created by Egor Petrov on 17.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

protocol ViewHolder {
    associatedtype ViewType

    var rootView: ViewType { get }
}

extension ViewHolder where Self: NSViewController {
    var rootView: ViewType {
        guard let view = self.view as? ViewType else {
            fatalError("View doesn't comform: \(ViewType.self)")
        }
        return view
    }
}
