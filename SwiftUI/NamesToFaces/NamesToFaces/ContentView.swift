//
//  ContentView.swift
//  NamesToFaces
//
//  Created by Shae Willes on 7/15/21.
//

import SwiftUI

struct ContentView: View {
    @State private var inputImage: UIImage? = nil
    @ObservedObject var namedFaces = NamedFaces()
    
    var body: some View {
        if inputImage == nil {
            NamedFacesListView(namedFaces: namedFaces, inputImage: $inputImage)
        } else {
            AddNamedFaceView(namedFaces: namedFaces, inputImage: $inputImage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
