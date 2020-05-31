//
//  CloseHandler.swift
//  Muna
//
//  Created by Alexander on 5/31/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

class CloseHandler {
    var close: VoidBlock?

    init(close: VoidBlock?) {
        self.close = close
    }
}
