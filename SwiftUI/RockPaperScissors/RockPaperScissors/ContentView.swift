//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Shae Willes on 9/2/20.
//  Copyright © 2020 Shae Willes. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let maxRounds = 10
    let validSelections = ["Rock", "Paper", "Scissors"]
    @State private var opponentSelection = Int.random(in: 0...2)
    @State private var playerShouldWin = Bool.random()
    @State private var playerSelection = 0
    @State private var score = 0
    @State private var roundNumber = 1
    @State private var gameOver = false
    
    //The player beat the computer whether they were supposed to or not
    var playerWon: Bool {
        if opponentSelection <= 1 {
            return playerSelection == opponentSelection + 1
        } else {
            return playerSelection == 0
        }
    }
    
    //The player made the correct selection based on what they were asked to do
    //Draws are currently being counted as losing
    var selectionIsCorrect: Bool {
        (playerShouldWin && playerWon) || (!playerShouldWin && !playerWon)
    }
    
    var finalRound: Bool {
        roundNumber == maxRounds
    }
    
    func optionSelected(selection: Int) {
        playerSelection = selection
        if selectionIsCorrect {score += 1}
        if finalRound {
            gameOver = true
        } else {
            roundNumber += 1
            newRound()
        }
    }
    
    func newRound() {
        opponentSelection = Int.random(in: 0...2)
        playerShouldWin = Bool.random()
    }
    
    func newGame() {
        score = 0
        roundNumber = 1
        newRound()
    }
    
    var body: some View {
        VStack() {
            Text("Opponent chose \(validSelections[opponentSelection])")
            Text(playerShouldWin ? "Try to Win!" : "Try to Lose!")
            HStack() {
                ForEach(0..<validSelections.count) { selection in
                    Button(action: {
                        optionSelected(selection: selection)
                    }) {
                        Text("\(validSelections[selection])")
                    }
                }
            }
            Text("Score: \(score)")
            Text("Current Round: \(roundNumber)/\(maxRounds)")
        }
        .alert(isPresented: $gameOver){
            Alert(title: Text("Game Over"), message: Text("You scored \(score)/10"), dismissButton: .default(Text("Try Again")) {
                newGame()
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
