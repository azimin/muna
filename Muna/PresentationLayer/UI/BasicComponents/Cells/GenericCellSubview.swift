//
//  GenericCellSubview.swift
//  Muna
//
//  Created by Alexander on 5/5/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Cocoa

public protocol GenericCellSubview {
    init()

    func setSelected(_ selected: Bool, animated: Bool)
    func setHighlighted(_ highlighted: Bool, animated: Bool)
}

extension GenericCellSubview {
    public func setSelected(_ selected: Bool, animated: Bool) {}
    public func setHighlighted(_ highlighted: Bool, animated: Bool) {}
}
