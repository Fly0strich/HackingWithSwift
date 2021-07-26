//
//  AddNamedFaceView.swift
//  NamesToFaces
//
//  Created by Shae Willes on 7/25/21.
//

import SwiftUI

struct AddNamedFaceView: View {
    @State private var inputName = ""
    @State private var locationName = ""
    @State private var showingAddError = false
    @State private var showingImagePicker = false
    @State private var addErrorTitle = ""
    @State private var addErrorMessage = ""
    
    @ObservedObject var namedFaces: NamedFaces
    
    @Binding var inputImage: UIImage?
    
    let locationFetcher = LocationFetcher()
    
    var body: some View {
        VStack() {
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
            
            TextField("Enter a name for your current location", text: $locationName)
                .padding()
            
            HStack {
                Button("Cancel") {
                    inputImage = nil
                    inputName = ""
                }
                .padding()
                
                Spacer()
                
                Button("Done") {
                    if inputName != "" {
                        addNamedFace()
                        inputImage = nil
                        inputName = ""
                    }
                    else {
                        addErrorTitle = "Unable to add new face"
                        addErrorMessage = "Please enter the names of the person and your location"
                        showingAddError = true
                    }
                }
                .padding()
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
        }
        .onAppear(perform: locationFetcher.start)
        .alert(isPresented: $showingAddError) {
            Alert(title: Text(addErrorTitle), message: Text(addErrorMessage), dismissButton: .default(Text("Ok")))
        }
    }
    
    func addNamedFace() {
        if let currentLocation = locationFetcher.lastKnownLocation {
            let currentLocationPoint = CodableMKPointAnnotation()
            currentLocationPoint.coordinate = currentLocation
            currentLocationPoint.title = locationName
            namedFaces.collection.append(NamedFace(id: UUID(), face: inputImage, name: inputName, locationMet: currentLocationPoint))
        } else {
            addErrorTitle = "Unable to add face"
            addErrorMessage = "Please allow our app access to your location in iPhone Settings"
            showingAddError = true
        }
        
        namedFaces.collection.sort()
    }
}
