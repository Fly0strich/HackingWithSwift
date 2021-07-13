//
//  ContentView.swift
//  BucketList
//
//  Created by Shae Willes on 7/9/21.
//

import SwiftUI

struct ContentView: View {
    @State private var isUnlocked = false
    
    var body: some View {
        Group {
            if isUnlocked {
                BucketListView()
            } else {
                UserAuthenticationView(isUnlocked: $isUnlocked)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



