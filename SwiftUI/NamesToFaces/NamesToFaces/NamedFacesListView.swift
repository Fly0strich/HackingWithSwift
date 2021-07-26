//
//  NamedFacesListView.swift
//  NamesToFaces
//
//  Created by Shae Willes on 7/25/21.
//

import SwiftUI

struct NamedFacesListView: View {
    @State private var showingImagePicker = false
    @ObservedObject var namedFaces: NamedFaces
    @Binding var inputImage: UIImage?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(namedFaces.collection) { namedFace in
                    NavigationLink(destination: NamedFaceDetailView(namedFace: namedFace)) {
                        HStack {
                            Image(uiImage: namedFace.face!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                            Text(namedFace.name)
                        }
                    }
                }
                .onDelete(perform: removeNamedFace)
            }
            .navigationBarTitle("Names To Faces")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
    }
    
    func removeNamedFace(at offsets: IndexSet) {
        namedFaces.collection.remove(atOffsets: offsets)
    }
}
