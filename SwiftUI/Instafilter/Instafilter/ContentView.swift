//
//  ContentView.swift
//  Instafilter
//
//  Created by Shae Willes on 6/18/21.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    @State private var currentFilter: CIFilter = .sepiaTone()
    @State private var filterIntensity: Double = 0.5
    @State private var filterRadius: Double = 0.5
    @State private var filterScale: Double = 0.5
    @State private var showingImagePicker = false
    @State private var showingFilterSheet = false
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    let context = CIContext()
    
    var body: some View {
        let intensity = Binding<Double> (
            get: {
                filterIntensity
            },
            set: {
                filterIntensity = $0
                applyProcessing()
            }
        )
        
        let radius = Binding<Double> (
            get: {
                filterRadius
            },
            set: {
                filterRadius = $0
                applyProcessing()
            }
        )
        
        let scale = Binding<Double> (
            get: {
                filterScale
            },
            set: {
                filterScale = $0
                applyProcessing()
            }
        )
            
        return NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)
                    
                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text("Tap to select a photo")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .onTapGesture {
                    showingImagePicker = true
                }
                
                HStack {
                    Text("Intensity")
                    Slider(value: intensity)
                }
                .padding([.horizontal, .top])
                
                HStack {
                    Text("Radius")
                    Slider(value: radius)
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Scale")
                    Slider(value: scale)
                }
                .padding([.horizontal, .bottom])
                
                HStack {
                    Button(currentFilter.name.dropFirst(2)) {
                        showingFilterSheet = true
                    }
                    
                    Spacer()
                    
                    Button("Save") {
                        guard processedImage != nil else {
                            alertTitle = "Oops!"
                            alertMessage = "No photo selected"
                            showingAlert = true
                            return
                        }
                        
                        let imageSaver = ImageSaver()
                        
                        imageSaver.successHandler = {
                            alertTitle = "Success!"
                            alertMessage = "Your photo has been saved"
                        }
                        
                        imageSaver.errorHandler = {
                            alertTitle = "Oops"
                            alertMessage = "\($0)"
                        }
                        
                        showingAlert = true
                        imageSaver.writeToPhotoAlbum(image: processedImage!)
                    }
                }
                .padding([.horizontal, .bottom])
                .navigationBarTitle("Instafilter")
                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: $inputImage)
                }
                .actionSheet(isPresented: $showingFilterSheet) {
                    ActionSheet(title: Text("Select a filter"), buttons: [
                        .default(Text("Crystallize")) { self.setFilter(CIFilter.crystallize()) },
                        .default(Text("Edges")) { self.setFilter(CIFilter.edges()) },
                        .default(Text("Gaussian Blur")) { self.setFilter(CIFilter.gaussianBlur()) },
                        .default(Text("Pixellate")) { self.setFilter(CIFilter.pixellate()) },
                        .default(Text("Sepia Tone")) { self.setFilter(CIFilter.sepiaTone()) },
                        .default(Text("Unsharp Mask")) { self.setFilter(CIFilter.unsharpMask()) },
                        .default(Text("Vignette")) { self.setFilter(CIFilter.vignette()) },
                        .cancel()
                    ])
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
                }
            }
        }
    }
    
    func loadImage() {
        guard inputImage != nil else { return }
        let beginImage = CIImage(image: inputImage!)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterScale * 10, forKey: kCIInputScaleKey) }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgImg = context.createCGImage(outputImage, from: outputImage.extent) {
            processedImage = UIImage(cgImage: cgImg)
            image = Image(uiImage: processedImage!)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
