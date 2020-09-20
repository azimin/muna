//
//  AssistentService.swift
//  Muna
//
//  Created by Alexander on 9/17/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import Foundation

struct AssistentTitle {
    var title: String

    var leftColor: ColorStyle
    var rightColor: ColorStyle

    static var `default`: AssistentTitle {
        return .init(
            title: "Smart Assistent",
            leftColor: ColorStyle.assitentLeftColor,
            rightColor: ColorStyle.assitentRightColor
        )
    }
}

protocol AssistentServiceProtocol {
    var currentTitle: Observable<AssistentTitle> { get }

    var numberOfItems: Int { get }
    func item(at index: Int) -> AssistentItem

    func cancelItem(at index: Int)
}

class AssistentService: AssistentServiceProtocol {
    var currentTitle: Observable<AssistentTitle> = .init(.default)

    var numberOfItems: Int {
        return 0
    }

    func item(at index: Int) -> AssistentItem {
        return .shortcutOfTheDay(shortcut: .init(key: .a, modifiers: .shift))
    }

    func cancelItem(at index: Int) {
        print(index)
    }
}
