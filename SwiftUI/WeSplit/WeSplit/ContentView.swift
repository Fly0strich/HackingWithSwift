//
//  ContentView.swift
//  WeSplit
//
//  Created by Shae Willes on 8/11/20.
//  Copyright © 2020 Shae Willes. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let tipPercentages = [0, 5, 10, 15, 20, 25]
    @State private var checkAmount = ""
    @State private var numberOfPeople = 0 //sets number of people picker to 2 as default
    @State private var tipSelection = 4 //sets tip percentage to 20 as default
    
    var totalWithTip: Double {
        let tipPercentage = Double(tipPercentages[tipSelection])/100
        let orderAmount = Double(checkAmount) ?? 0
        let tipValue = tipSelection > 0 ? (orderAmount * tipPercentage) : 0
        return orderAmount + tipValue
    }

    var totalPerPerson: Double {
        return totalWithTip / Double(numberOfPeople + 2)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Check Amount:")) {
                    TextField("Enter Check Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)
                }
                
                Section (header: Text("Number of People")){
                    Picker("", selection: $numberOfPeople) {
                        ForEach(2 ..< 100) {
                            Text("\($0) People")
                        }
                    }
                }
                
                Section(header: Text("Tip Percentage:")){
                    Picker("Tip Percentage:", selection: $tipSelection) {
                        ForEach(0 ..< tipPercentages.count) {
                            Text("\(tipPercentages[$0])%")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Total With Tip:")) {
                    Text("$\(totalWithTip, specifier: "%.2f")")
                        .foregroundColor((tipSelection == 0) ? .red : .black)
                }
                
                Section(header: Text("Amount Per Person:")) {
                    Text("$\(totalPerPerson, specifier: "%.2f")")
                }
            }
            .navigationBarTitle("Check Splitter")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
