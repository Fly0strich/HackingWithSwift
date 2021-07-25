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
            
            Spacer()
        }
    }
}

struct NamedFaceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NamedFaceDetailView(namedFace: NamedFace(id: UUID(), face: nil, name: "No Name"))
    }
}
