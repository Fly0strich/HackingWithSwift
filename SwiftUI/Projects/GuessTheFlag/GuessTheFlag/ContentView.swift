//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Shae Willes on 8/13/20.
//  Copyright © 2020 Shae Willes. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var rotationAmount = 0.0
    @State private var buttonOpacity = 1.0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
                
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0..<3) { number in
                    Button(action: {
                        withAnimation {
                            self.flagTapped(number)
                        }
                    }) {
                        FlagImage(flagImageFile: self.countries[number])
                    }
                    .rotation3DEffect(.degrees(number == self.correctAnswer ? self.rotationAmount : 0.0), axis: (x: 0, y: 1, z: 0))
                    .opacity(number != self.correctAnswer ? self.buttonOpacity : 1.0)
                }

                Text("Current Score: \(score)")
                    .foregroundColor(.white)
                                
                Spacer()
            }
        }
        .alert(isPresented: $showingScore){
            Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
            rotationAmount += 360
            buttonOpacity -= 0.75
        } else {
            scoreTitle = "Wrong! That is the flag of \(countries[number])"
            buttonOpacity = 0
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        rotationAmount = 0
        buttonOpacity = 1
    }
}

struct FlagImage: View {
    var flagImageFile: String
    
    var body: some View {
        Image(flagImageFile)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
