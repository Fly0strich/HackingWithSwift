//
//  NamedFaceDetailView.swift
//  NamesToFaces
//
//  Created by Shae Willes on 7/18/21.
//

import SwiftUI

struct NamedFaceDetailView: View {
    let namedFace: NamedFace
    
    var body: some View {
        VStack {
            Text(namedFace.name)
                .font(.largeTitle)
            
            Image(uiImage: namedFace.face!)
                .resizable()
                .scaledToFit()
                .padding(.bottom)
            
            Text("You first met at this location")
                .font(.caption)
            
            MapView(locationMet: namedFace.locationMet)
                .frame(width: 200, height: 200)
        }
    }
}
