//
//  ContentView.swift
//  Muna
//
//  Created by Egor Petrov on 02.05.2020.
//  Copyright © 2020 Abstract. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var topPadding: CGFloat

    var body: some View {
        ScrollView {
          ForEach(0..<50) { i in
            Text("\(i)")
                .background(Color.green).frame(height: 200)
            CircleImage(object: .init())
              Divider()
          }
        }
//        List(0..<50) { (index) in
//            Text("\(index)")
//                .background(Color.green).frame(height: 200)
//            CircleImage(object: .init())
//        }
//        .listRowBackground(Color.green)
//        .padding(.top, self.topPadding)
//        .background(Color.green)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(topPadding: 20)
            .frame(width: 480, height: 1000)
    }
}
