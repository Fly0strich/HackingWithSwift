//
//  ContentView.swift
//  BetterRest
//
//  Created by Shae Willes on 9/2/20.
//  Copyright © 2020 Shae Willes. All rights reserved.
//

import SwiftUI
import CoreML

struct ContentView: View {
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var bedTime: String {
        do {
            let model: SleepCalculator = try SleepCalculator(configuration: MLModelConfiguration())
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: sleepTime)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime"
            showingAlert = true
            return alertMessage
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want to wake up?")) {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                .font(.headline)
                
                Section(header: Text("Desired amount of sleep")) {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                .font(.headline)
                
                Section(header: Text("Daily coffee intake")) {
                    Text("Coffe Amount: \(coffeeAmount)")
                    Picker("", selection: $coffeeAmount) {
                        ForEach(1..<21, id: \.self) {number in
                            Text(number == 1 ? "\(number) cup" : "\(number) cups")
                        }
                    }
                }
                .font(.headline)
                
                Section(header: Text("Your recommended bedtime is")) {
                    Text("\(bedTime)")
                    .font(.title)
                }
                .font(.headline)
                
            }
            .navigationBarTitle("BetterRest")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
