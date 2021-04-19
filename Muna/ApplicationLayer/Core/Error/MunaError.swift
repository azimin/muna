//
//  MunaError.swift
//  Muna
//
//  Created by Egor Petrov on 19.04.2021.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Foundation

enum MunaError: LocalizedError {

    case cantGetInAppProducts
    
    var errorDescription: String? {
        switch self {
        case .cantGetInAppProducts:
            return "Сan't load products"
        }
    }
}
