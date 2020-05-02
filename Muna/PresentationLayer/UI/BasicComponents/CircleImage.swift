//
//  CircleImage.swift
//  Muna
//
//  Created by Alexander on 5/2/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

import SwiftUI

class SomeObject {
    var a: String = ""
}

struct CircleImage: View {
    var object: SomeObject

    var body: some View {
        Image("img")
            .resizable()
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white, lineWidth: 2)
        )
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(object: .init())
    }
}
