//
//  ContentView.swift
//  SpeedMath
//
//  Created by Dinesh Vijaykumar on 13/05/2020.
//  Copyright © 2020 Dinesh Vijaykumar. All rights reserved.
//

import SwiftUI

enum Position  {
    case answered, current, upcoming
}

struct Question {
    let text: String
    let actualAnswer: String
    var userAnswer = ""
    var padding = 0
    
    init() {
        let left = Int.random(in: 1...10)
        let right = Int.random(in: 1...10)
        
        text = "\(left) + \(right) = "
        actualAnswer = "\(left + right)"
        
        if left < 10 {
            padding += 1
        }
        
        if right < 10 {
            padding += 1
        }
    }
}

struct QuestionRow: View {
    var question: Question
    var position: Position
    
    var positionColor:Color {
        if position == .answered {
            if question.actualAnswer == question.userAnswer {
                return Color.green.opacity(0.8)
            } else {
                return Color.red.opacity(0.8)
            }
        } else if position == .upcoming {
            return Color.black.opacity(0.5)
        } else {
            return Color.blue
        }
    }
    
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                if question.padding > 0 {
                    Text(String(repeating: " ", count: question.padding))
                }
                Text(question.text)
            }
            .padding([.top, .bottom, .leading])
            
            ZStack {
                Text(" ")
                .padding()
                .frame(width: 150)
                    .overlay(RoundedRectangle(cornerRadius: 10).fill(positionColor))
                
                Text(question.userAnswer)
            }
        }
        .font(.system(size: 48, weight: .regular, design: .monospaced))
        .foregroundColor(Color.white)
    }
}

struct ContentView: View {
    @State private var questions = [Question]()
    @State private var currentQuestionNumber = 0
    
    var score: Int {
        var total = 0
        
        for i in 0..<currentQuestionNumber {
            if questions[i].userAnswer == questions[i].actualAnswer {
                total += 1
            }
        }
        return total
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<questions.count, id: \.self) { index in
                QuestionRow(question: self.questions[index], position: self.position(for: index))
                    .offset(x: 0, y: CGFloat(index) * 100 - CGFloat(self.currentQuestionNumber) * 100)
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Text("Score: \(score)")
                    .padding()
                    .background(Capsule().fill(Color.white.opacity(0.8)))
                    .animation(nil)
                }
                .font(.largeTitle)
                .foregroundColor(Color.black)
                .padding()
                
                Spacer()
            }
            .padding()
        }
        .frame(width: 1000, height: 600)
        .background(LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .onAppear(perform: createQuestions)
        .onReceive(NotificationCenter.default.publisher(for: .enterNumber)) { note in
            guard let number = note.object as? Int else { return }
            
            if self.questions[self.currentQuestionNumber].userAnswer.count < 3 {
                self.questions[self.currentQuestionNumber].userAnswer += String(number)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .removeNumber)) { _ in
            _ = self.questions[self.currentQuestionNumber].userAnswer.popLast()
        }
        .onReceive(NotificationCenter.default.publisher(for: .submitNumber)) { _ in
            if self.questions[self.currentQuestionNumber].userAnswer.isEmpty == false {
                withAnimation {
                    self.currentQuestionNumber += 1
                }
            }
        }
    }
    
    func createQuestions() {
        for _ in 1...50 {
            questions.append(Question())
        }
    }
    
    func position(for index: Int) -> Position {
        if index < currentQuestionNumber {
            return .answered
        } else if index == currentQuestionNumber {
            return .current
        } else {
            return .upcoming
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
