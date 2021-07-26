//
//  AddNamedFaceView.swift
//  NamesToFaces
//
//  Created by Shae Willes on 7/25/21.
//

import SwiftUI

struct AddNamedFaceView: View {
    @State private var inputName: String = ""
    @State private var showingAddError = false
    @State private var showingImagePicker = false
    @ObservedObject var namedFaces: NamedFaces
    @Binding var inputImage: UIImage?
    
    var body: some View {
        VStack {
            if inputImage != nil {
                Image(uiImage: inputImage!)
                    .resizable()
                    .scaledToFit()
                    .onTapGesture {
                        showingImagePicker = true
                    }
            }
            
            TextField("Enter this person's name", text: $inputName)
                .padding()
            
            HStack {
                Button("Done") {
                    if inputName != "" {
                        addNamedFace()
                        inputImage = nil
                        inputName = ""
                    }
                    else {
                        showingAddError = true
                    }
                }
                
                Button("Cancel") {
                    inputImage = nil
                    inputName = ""
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
        }
        .alert(isPresented: $showingAddError) {
            Alert(title: Text("Face not added"), message: Text("Please enter a name"), dismissButton: .default(Text("Ok")))
        }
    }
    
    func addNamedFace() {
        namedFaces.collection.append(NamedFace(id: UUID(), face: inputImage, name: inputName))
        namedFaces.collection.sort()
    }
}
