//
//  ContentView.swift
//  AniMultiplication
//
//  Created by Shae Willes on 9/11/20.
//  Copyright © 2020 Shae Willes. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var difficulty = 0
    @State private var numQuestionsIndex = 0
    @State private var score = 0
    @State private var currentQuestionIndex = 0
    @State private var settingsSelected = false
    @State private var gameOver = false
    @State private var questions = [Question]()
    @State private var answer = "?"
    
    var body: some View {
        Group {
            if !settingsSelected {
                SettingSelectionView(difficulty: $difficulty, numQuestionsIndex: $numQuestionsIndex, settingsSelected: $settingsSelected, questions: $questions)
            } else if !gameOver {
                GameplayView(score: $score, gameOver: $gameOver, answer: $answer, currentQuestionIndex: $currentQuestionIndex, questions: questions.shuffled())
            } else {
                GameOverView()
            }
        }
    }

}

//Allows user to select their desired settings for the game and generates questions based on those settings
struct SettingSelectionView: View {
    @Binding var difficulty: Int
    @Binding var numQuestionsIndex: Int
    @Binding var settingsSelected: Bool
    @Binding var questions: [Question]
    
    let numQuestionsOptions = ["5", "10", "20", "All"]
    let maxDifficulty = 12
    let indexOfAllQuestions = 3
    
    var body: some View {
        NavigationView{
            VStack {
                Form {
                    Section(header: Text("Select Difficulty:")) {
                        Stepper(value: $difficulty, in: 1...maxDifficulty, step: 1) {
                            Text("\(difficulty)")
                        }
                    }
                    .font(.headline)
                                        
                    Section(header: Text("Select Number of Questions to Practice:")) {
                        Picker("", selection: $numQuestionsIndex) {
                            ForEach(0 ..< numQuestionsOptions.count) {number in
                                Text(numQuestionsOptions[number])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .font(.headline)
                }
                
                Button(action: {
                    generateQuestions()
                    settingsSelected.toggle()
                }) {
                    Text("Start")
                }
                .padding(20)
            }
            .navigationBarTitle(Text("Select Settings"))
        }
    }
    
    func generateQuestions() {
        if numQuestionsIndex < indexOfAllQuestions {
            //player chose a scpecific number of questions to answer
            for _ in (0..<Int(numQuestionsOptions[numQuestionsIndex])!) {
                let firstFactor = Int.random(in: 0...difficulty)
                let secondFactor = Int.random(in: 0...difficulty)
                questions.append(Question(firstFactor: firstFactor, secondFactor: secondFactor))
            }
        } else {
            //player chose to answer all possible questions of the selected difficulty
            for firstFactor in (0...difficulty) {
                var secondFactor = 0
                while secondFactor <= difficulty {
                    questions.append(Question(firstFactor: firstFactor, secondFactor: secondFactor))
                    secondFactor+=1
                }
            }
        }
    }
    
}

//Allows user to answer all questions that were generated based on their selected settings
struct GameplayView: View {
    @Binding var score: Int
    @Binding var gameOver: Bool
    @Binding var answer: String
    @Binding var currentQuestionIndex: Int
    
    let questions: [Question]
    let buttonsPerRow = 3
            
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text(questions[currentQuestionIndex].question)
                    Text(answer)
                }
                HStack {
                    ForEach(0..<buttonsPerRow) { buttonPosition in
                    Button(action: {
                        if answer == "?" {
                            answer = "\(buttonPosition + 1)"
                        }
                        else {
                            answer += "\(buttonPosition + 1)"
                        }
                        }) {
                            Text("\(buttonPosition + 1)")
                        }
                    }
                }
                HStack {
                    ForEach(buttonsPerRow..<buttonsPerRow * 2) { buttonPosition in
                    Button(action: {
                        if answer == "?" {
                            answer = "\(buttonPosition + 1)"
                        }
                        else {
                            answer += "\(buttonPosition + 1)"
                        }
                        }) {
                            Text("\(buttonPosition + 1)")
                        }
                    }
                }
                HStack {
                    ForEach(buttonsPerRow * 2..<buttonsPerRow * 3) { buttonPosition in
                    Button(action: {
                        if answer == "?" {
                            answer = "\(buttonPosition + 1)"
                        }
                        else {
                            answer += "\(buttonPosition + 1)"
                        }
                        }) {
                            Text("\(buttonPosition + 1)")
                        }
                    }
                }
                HStack {
                    Button(action: {
                        answer = "?"
                        }) {
                            Text("X")
                        }
                    Button(action: {
                        if answer == "?" {
                            answer = "0"
                        }
                        else {
                            answer += "0"
                        }
                        }) {
                            Text("0")
                        }
                    Button(action: {
                        submitAnswer()
                        }) {
                            Text("Enter")
                        }
                }
                Spacer()
                Text("Current Question: \(currentQuestionIndex + 1) / \(questions.count)")
                Text("Score: \(score)")
            }.navigationBarTitle(Text("Let's Do Some Math!"))
        }
    }
    
    func submitAnswer() {
        if (answer == String(questions[currentQuestionIndex].answer)) {
            score += 1
        }
        currentQuestionIndex += 1
        answer = "?"
        if (currentQuestionIndex == questions.count) {
            gameOver = true
            currentQuestionIndex = 0
        }
    }
}

//Allows user to view their score and start a new game
struct GameOverView: View {
    var body: some View {
        Text("Game Over")
    }
}

//Creates a multiplication question and answer from two factors
struct Question {
    var question: String
    var answer: Int
    
    init (firstFactor: Int, secondFactor: Int) {
        question = "\(firstFactor) x \(secondFactor) ="
        answer = firstFactor * secondFactor
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

