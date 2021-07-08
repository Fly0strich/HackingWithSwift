//
//  ContentView.swift
//  UnitConverter
//
//  Created by Shae Willes on 8/12/20.
//  Copyright © 2020 Shae Willes. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    let temperatureUnits = ["Celsius", "Fahrenheit", "Kelvin"]
    
    @State private var selectedInputUnit = 0
    @State private var selectedOutputUnit = 1
    @State private var enteredText = ""
    
    var convertedValue: Double {
        let enteredValue = Double(enteredText) ?? 0
        
        switch temperatureUnits[selectedOutputUnit] {
        case "Celsius" :
            if temperatureUnits[selectedInputUnit] == "Fahrenheit" {
                return (enteredValue - 32) * (5/9)
            } else if temperatureUnits[selectedInputUnit] == "Kelvin" {
                return enteredValue - 273.15
            } else {
                return enteredValue
            }
        case "Fahrenheit":
            if temperatureUnits[selectedInputUnit] == "Celsius" {
                return (enteredValue * (9/5)) + 32
            } else if temperatureUnits[selectedInputUnit] == "Kelvin" {
                return ((enteredValue - 273.15) * (9/5)) + 32
            } else {
                return enteredValue
            }
        case "Kelvin":
            if temperatureUnits[selectedInputUnit] == "Celsius" {
                return enteredValue + 273.15
            } else if temperatureUnits[selectedInputUnit] == "Fahrenheit" {
                return ((enteredValue - 32) * (5/9)) + 273.15
            } else {
                return enteredValue
            }
        default:
            return 0
        }
    }
    
    
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Input Unit of Measure")) {
                    Picker("InputUnit of Measure", selection: $selectedInputUnit) {
                        ForEach(0 ..< temperatureUnits.count) {
                            Text("\(self.temperatureUnits[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Output Unit of Measure")) {
                    Picker("", selection: $selectedOutputUnit) {
                        ForEach(0 ..< temperatureUnits.count) {
                            Text("\(self.temperatureUnits[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Enter Degrees \(temperatureUnits[selectedInputUnit])")) {
                    TextField("0", text: $enteredText)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("\(temperatureUnits[selectedOutputUnit]) Equivalent")) {
                    Text("\(convertedValue, specifier: "%.3f")")
                }
            }
            .navigationBarTitle("Temperature Converter")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
