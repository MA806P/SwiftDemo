//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by apple on 2026/1/14.
//

import Foundation
import SwiftData

typealias Peg = String

@Model class CodeBreaker {
    var name: String
    @Relationship(deleteRule: .cascade) var masterCode: Code = Code(kind: .master(isHidden:true))
    @Relationship(deleteRule: .cascade) var guess: Code = Code(kind: .guess)
    @Relationship(deleteRule: .cascade) var _attempts: [Code] = []
    var pegChoices: [Peg]
    @Transient var startTime: Date?
    var endTime: Date?
    var elapsedTime: TimeInterval = 0
    var lastAttemptDate: Date? = Date.now
    
    var attempts: [Code] { //每次重启获取到的按顺序显示
        get { _attempts.sorted { $0.timestamp > $1.timestamp } }
        set { _attempts = newValue }
    }
    
    init(name: String = "Code Breaker", pegChoices: [Peg]) {
        self.name = name
        self.pegChoices = pegChoices
        masterCode.randomize(from: pegChoices)
    }
    
    func startTimer() {
        if startTime == nil, !isOver {
            startTime = .now
            elapsedTime += 0.00001
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
        //var attempt = guess
        //attempt.kind = attempt(attempt.match(against: masterCode)
        
        let attempt = Code(
            kind: .attempt(guess.match(against: masterCode)),
            pegs: guess.pegs
        )
        
        attempts.insert(attempt, at: 0)
        lastAttemptDate = .now
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



//extension CodeBreaker: Identifiable, Hashable {
//    static func ==(lhs: CodeBreaker, rhs: CodeBreaker) -> Bool {
//        lhs.id == rhs.id
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//}



