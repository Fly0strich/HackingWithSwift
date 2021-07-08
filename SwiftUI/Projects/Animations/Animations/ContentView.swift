//
//  ContentView.swift
//  Animations
//
//  Created by Shae Willes on 9/5/20.
//  Copyright © 2020 Shae Willes. All rights reserved.
//

import SwiftUI

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(amount), anchor: anchor).clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct ContentView: View {
    @State private var colorsMixed = true
    
    var body: some View {
        ZStack {
            Color.black
            
            VStack {
                Button(colorsMixed ? "Tap to Separate" : "Tap to Combine") {
                    withAnimation{
                        self.colorsMixed.toggle()
                    }
                }
                .frame(width: 200, height: 200)
                .background(colorsMixed ? Color.purple : Color.red)
                .foregroundColor(.white)
                
                if !colorsMixed {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width:200, height: 200)
                        .transition(.pivot)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
