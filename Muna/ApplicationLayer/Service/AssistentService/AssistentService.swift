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

    var firstColor: ColorStyle
    var secondColor: ColorStyle
}

protocol AssistentServiceProtocol {
    var currentTitle: Observable<AssistentTitle> { get }

    var numberOfItems: Int { get }
    func item(at index: Int) -> AssistentItem

    func cancelItem(at index: Int)
}
