//
//  NSAttributedString+Calculations.swift
//  Muna
//
//  Created by Egor Petrov on 02.05.2021.
//  Copyright © 2021 Abstract. All rights reserved.
//

import Foundation

extension NSAttributedString {
    func calculateHeight(forWidth width: CGFloat) -> CGFloat {
        let options = NSString.DrawingOptions.usesLineFragmentOrigin
        let boundingRect = self.boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: options,
            context: nil
        )
        return ceil(boundingRect.height)
    }

    func calculateWidth(forHeight height: CGFloat) -> CGFloat {
        let options = NSString.DrawingOptions.usesLineFragmentOrigin
        let boundingRect = self.boundingRect(
            with: CGSize(width: .greatestFiniteMagnitude, height: height),
            options: options,
            context: nil
        )
        return ceil(boundingRect.width)
    }
}
