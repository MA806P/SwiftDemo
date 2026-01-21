//
//  Code.swift
//  CodeBreaker
//
//  Created by apple on 2026/1/14.
//


import SwiftUI
//import SwiftUICore

//extension Peg {
//    static let missing = Color.clear
//}

struct Code {
    var kind: Kind
    var pegs: [Peg] = Array(repeating: Code.missingPeg, count: 4)
    
    static let missingPeg: Peg = .clear
    
    enum Kind: Equatable {
        case master(isHidden: Bool)
        case guess
        case attempt([Match])
        case unknown
    }
    
    var isHidden: Bool {
        switch kind {
        case .master(let isHidden): return isHidden
        default: return false
        }
    }
    
    mutating func randomize(from pegChoices: [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missingPeg
        }
        print(self)
    }
    
    mutating func reset() {
        pegs = Array(repeating: Code.missingPeg, count: 4)
    }
    
    var matches: [Match]? {
        switch kind {
        case .attempt(let matches):
            return matches
        default:
            return nil
        }
    }
    
    
    func match(against otherCode: Code) -> [Match] {
        var pegToMatch = otherCode.pegs
        let backwardExactMatches = pegs.indices.reversed().map { index in
            if pegToMatch.count > index, pegToMatch[index] == pegs[index] {
                pegToMatch.remove(at: index)
                return Match.exact
            } else {
                return .nomatch
            }
        }
        
        let exactMatches = Array(backwardExactMatches.reversed())
        return pegs.indices.map { index in
            if exactMatches[index] != .exact, let matchIndex = pegToMatch.firstIndex(of: pegs[index]) {
                pegToMatch.remove(at: matchIndex)
                return .inexact
            } else {
                return exactMatches[index]
            }
        }
    }
    
    /*
    func match(against otherCode: Code) -> [Match] {
        var result: [Match] = Array(repeating: .nomatch, count: peg.count)
        var pegToMatch = otherCode.peg
        for index in peg.indices.reversed() {//这里逆序，因为 pegToMatch 匹配上了下面会移除，从后往前顺序不会影响
            if pegToMatch.count > index, pegToMatch[index] == peg[index] {
                result[index] = .exact
                pegToMatch.remove(at: index)
            }
        }
        
        for index in peg.indices {
            if result[index] != .exact {
                if let matchIndex = pegToMatch.firstIndex(of: peg[index]) {
                    result[index] = .inexact
                    pegToMatch.remove(at: matchIndex)
                }
            }
        }
        return result
    }*/
}
