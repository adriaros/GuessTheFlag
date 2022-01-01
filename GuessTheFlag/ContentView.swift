//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Adrià Ros on 15/3/21.
//

import SwiftUI

struct Flag: ViewModifier {
   
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 0.5))
            .shadow(color: .black, radius: 2)
    }
}

extension View{
    
    var flagType: some View {
        self.modifier(Flag())
    }
}

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var score = 0
    
    @State private var animationDegrees = 0.0
    @State private var animationOpacity = 1.0
    
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
                        withAnimation{
                            self.animationDegrees += 360
                            self.animationOpacity = 0.25
                        }
                    }) {
                        withAnimation {
                            flagViewOf(number)
                                .rotation3DEffect(.degrees(number == correctAnswer ? animationDegrees : 0.0), axis: (x: 0, y: 1, z: 0))
                                .opacity(number != correctAnswer ? animationOpacity : 1.0)
                        }
                    }
                }
                
                Spacer()
                
                VStack {
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
                resetAnimationValues()
            }
            )
        })
    }
    
    func flagTapped(_ number: Int) {
        scoreTitle = (number == correctAnswer) ? "Correct" : "Wrong"
        score = (number == correctAnswer) ? (score + 10) : 0
        scoreMessage = (number != correctAnswer) ? "You failed. This is the \(countries[number]) flag" : "Your score is \(score)" // 3.
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func resetAnimationValues() {
        animationDegrees = 0.0
        animationOpacity = 1.0
    }
}

extension ContentView {
    
    func flagViewOf(_ number: Int) -> some View {
        Image(self.countries[number])
            .renderingMode(.original)
            .flagType
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
