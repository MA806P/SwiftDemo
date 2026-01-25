//
//  Kind.swift
//  CodeBreaker
//
//  Created by YuZhou Ma on 2026/1/25.
//

//import Foundation


import Foundation

enum Kind: Equatable, CustomStringConvertible {
    case master(isHidden: Bool)
    case guess
    case attempt([Match])
    case unknown
    
    var description: String {
        switch self {
        case .master(let isHidden):
            return "master(\(isHidden))"
        case .guess:
            return "guess"
        case .attempt(let matches):
            let matchStr = matches.map { $0.rawValue }.joined(separator: ",")
            return "attempt(\(matchStr))"
        case .unknown:
            return "unknown"
        }
    }
    
    init(_ string: String) {
        let newStr = string.trimmingCharacters(in:.whitespacesAndNewlines)
        if newStr == "guess" {
            self = .guess
        }
        
        if newStr == "unknown" {
            self = .unknown
        }
        
        if newStr.hasPrefix("master("), newStr.hasSuffix(")") {
            let inner = String(newStr.dropFirst("master(".count).dropLast())
            switch inner {
            case "true":
                self = .master(isHidden: true)
                return
            case "false":
                self = .master(isHidden: false)
                return
            default:
                break
            }
        }
        
        if newStr.hasPrefix("attempt("), newStr.hasSuffix(")") {
            let inner = String(newStr.dropFirst("attempt(".count).dropLast())
            let matchString = inner.split(separator: ",").map(String.init)
            let matches = matchString.compactMap { Match(rawValue:$0) }
            self = .attempt(matches)
            return
        }
        
        self = .unknown
    }
    
    
    
}
