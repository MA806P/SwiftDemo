//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by apple on 2026/1/14.
//

import SwiftUI

typealias Peg = Color

@Observable class CodeBreaker {
    var name: String
    var masterCode: Code = Code(kind: .master(isHidden: true))
    var guess: Code = Code(kind: .guess)
    var attempts: [Code] = []
    var pegChoices: [Peg]
    var startTime: Date?
    var endTime: Date?
    var elapsedTime: TimeInterval = 0
    
    init(name: String = "Code Breaker", pegChoices: [Peg] = [.red, .green, .yellow, .blue]) {
        self.name = name
        self.pegChoices = pegChoices
        masterCode.randomize(from: pegChoices)
    }
    
    func startTimer() {
        if startTime == nil, !isOver {
            startTime = .now
        }
    }
    
    func pauseTimer() {
        if let startTime {
            elapsedTime += Date.now.timeIntervalSince(startTime)
        }
        startTime = nil
    }
    
    var isOver: Bool {
        attempts.first?.pegs == masterCode.pegs
    }
    
    func restart() {
        masterCode.kind = .master(isHidden: true)
        masterCode.randomize(from: pegChoices)
        guess.reset()
        attempts.removeAll()
        startTime = .now
        endTime = nil
        elapsedTime = 0
    }
    
    func attemptGuess() {
        guard !attempts.contains(where: { $0.pegs == guess.pegs }) else {
            return
        }
        var attempt = guess
        attempt.kind = .attempt(attempt.match(against: masterCode))
        attempts.insert(attempt, at: 0)
        guess.reset()
        if isOver {
            masterCode.kind = .master(isHidden: false)
            endTime = .now
            pauseTimer()
        }
    }
    
    func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
//    mutating func changeGuessPeg(at index: Int) {
//        let existingPeg = guess.pegs[index]
//        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
//            let newPeg = pegChoices[(indexOfExistingPegInPegChoices + 1)%pegChoices.count]
//            guess.pegs[index] = newPeg
//        } else {
//            guess.pegs[index] = pegChoices.first ?? Code.missingPeg
//        }
//    }
}



extension CodeBreaker: Identifiable, Hashable {
    static func ==(lhs: CodeBreaker, rhs: CodeBreaker) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}



