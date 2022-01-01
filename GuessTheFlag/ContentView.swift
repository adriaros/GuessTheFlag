//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Adrià Ros on 15/3/21.
//

import SwiftUI

// MARK: Challenge

// 1. Add an @State property to store the user’s score, modify it when they get an answer right or wrong, then display it in the alert.
// 2. Show the player’s current score in a label directly below the flags.
// 3. When someone chooses the wrong flag, tell them their mistake in your alert message – something like “Wrong! That’s the flag of France,” for example.

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = "" // 3.
    @State private var score = 0 // 1.
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                
                Spacer()
                
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                       flagTapped(number)
                    }) {
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 0.5))
                            .shadow(color: .black, radius: 2)
                    }
                }
                
                Spacer()
                
                VStack { // 2.
                    Text("Score: \(score)")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                Spacer()
            }
        }
        .alert(isPresented: $showingScore, content: {
            Alert(title: Text(scoreTitle),
                  message: Text(scoreMessage),
                  dismissButton: .default(Text("Continue")) {
                    askQuestion()
                  }
            )
        })
    }
    
    func flagTapped(_ number: Int) {
        scoreTitle = (number == correctAnswer) ? "Correct" : "Wrong"
        score = (number == correctAnswer) ? (score + 10) : 0 // 1.
        scoreMessage = (number != correctAnswer) ? "You failed. This is the \(countries[number]) flag" : "Your score is \(score)" // 3.
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
